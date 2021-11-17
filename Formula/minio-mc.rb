class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-11-16T20-37-36Z",
      revision: "d0c62eb584e57387fa62a8b6637b077aa3b2717d"
  version "20211116203736"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4853c36d0be3fcf56b3cb4fd691543b099dff81abfea27ee3d82d60ddf8dec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a14a62112c6bf69c94e550c2dccda2832f33b4b4e38554c351163bbda4f3885d"
    sha256 cellar: :any_skip_relocation, monterey:       "90454634b98b1f9b7c4936e179e43b2de71f86bcb2bc7a2bc59c52be58ec399b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a55fcb6dfb63e178c86506940a63755e192339dd3c8aa69551d41abb679e9a2b"
    sha256 cellar: :any_skip_relocation, catalina:       "fcf488c89ef1d64b051650ac36eefbc48e0cd8ccecdf2bf33f51fc4f1ed114df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a16c712cd1f0801b3d9a93af80fcc7c74fdf3586490201cf0aef6403882568f1"
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
