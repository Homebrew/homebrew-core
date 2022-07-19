class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-07-15T09-20-55Z",
      revision: "48e9183957fce660dcc32a36bbee6f3ee4a9d0e9"
  version "20220715092055"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb29408eb393c1b0a4ece5525ce8de78913784ca9cf11a19b4c0aedc8b4ce99b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d7a1595864fc895d8740d07fe81767c5fb7fad26e6a8766b186b04a955bad4f"
    sha256 cellar: :any_skip_relocation, monterey:       "a41b0245c1dca8e2dbee28d0f75024a1f15663918c872ecfd68f2a9f263fbaac"
    sha256 cellar: :any_skip_relocation, big_sur:        "a758d4ec160a8ed771ec2a5c563752604bc2f4c3107f5662c39a251e4281f526"
    sha256 cellar: :any_skip_relocation, catalina:       "fa5737718f082020daab1e082a3127a542764443b522bea9628a44ebcd08ba50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4693c84142a905b58be30cef028259f280c3dff4e882eaa3dad731247e88d502"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      EOS
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
