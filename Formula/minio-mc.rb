class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-12-20T23-43-34Z",
      revision: "0b2f0c9b4889f86c476c2b1e845a28c25e851d5b"
  version "20211220234334"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df704f1a62abe26c38ff4f99d68df68497de794e04f15ec92cb509f41130eeff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6ceab9ff232e22f15c22169d4396147fea8230e1451a8c31e3e16e0e0548ab5"
    sha256 cellar: :any_skip_relocation, monterey:       "2984b8c473e593ec398749df99273fb8c4bdbbca331a255e25857ac38f672328"
    sha256 cellar: :any_skip_relocation, big_sur:        "566b66d98710ebb62e23827293078041b18cbc9258033ed250863e6ffbd790b7"
    sha256 cellar: :any_skip_relocation, catalina:       "3257711a7fb2e27b5b3918e21816b0df7c245a66b20464ebea62ab187e4c8ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0db15cc85ccd75971a0d65f8cb15401e599e0c6e5b222607cf26611ebef5c10f"
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
