class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-05-26T19-19-26Z",
      revision: "8d65ee71302e662669bbbf57b834a4aa38c94bdc"
  version "20210526191926"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d89f39198093c04601d3318e94b4cfc09a9bddfcbca25b967b4688ec04b381d"
    sha256 cellar: :any_skip_relocation, big_sur:       "45456e0e492ba4f9030cbf51472251c4ecc1c7a925dbbfd38d49dad96fd7c14a"
    sha256 cellar: :any_skip_relocation, catalina:      "c8cb3b8668d4b442ff77115e14cd88fd6e0c537e2fa6cdd5bd0ef7ab98166366"
    sha256 cellar: :any_skip_relocation, mojave:        "c8b6403b19ae655535db32b1cb02a5e7698272a1b9ae8cb8feba973bcdd0d1b1"
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
