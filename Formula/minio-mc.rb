class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-01-07T06-01-38Z",
      revision: "aed4d3062f80d44384637832ad54c530ec32924e"
  version "20220107060138"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed11ff369e7c12361990443fb814ffa4c607f6e0575eb50206968923ba92aa4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3687f977ea57d600603576e40d70287c10479492a0e1f4a51261083f086e00c"
    sha256 cellar: :any_skip_relocation, monterey:       "1aec24a487d1984d0892936d05ac6d608201cf5f8b5fac0c258a62905f062194"
    sha256 cellar: :any_skip_relocation, big_sur:        "28a148b57b83b282afe609ff78efe05697668bad1f0ad99a92d297e1a93eedf3"
    sha256 cellar: :any_skip_relocation, catalina:       "eeef964ab8b9f057084a1d05fbfc466070c727e339f5d3039b9ddb531bb831ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae50b8c0d38b5312468f412beb3caec931d5539e8d99cab31a0b367176175534"
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
