class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-10-06T01-20-06Z",
      revision: "1a832ed01811a035b7855b9578c9b66d83269fcd"
  version "20221006012006"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06500922fdc3329a52704531f2fd697d236f6525f40627ae532c26516d7b7044"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa19ec52637b6fa882b8dd11bab52d8ec4435aafb0c712180fc75a78bd80a643"
    sha256 cellar: :any_skip_relocation, monterey:       "d6ec1253cc6645c7b559af5838e17154ba913eaab7113c5fa2ab82fd2e6b3e4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "28623b66f7167d824b81c5a36414fa4dec8a1adaf56b6c44ba10148a496ea839"
    sha256 cellar: :any_skip_relocation, catalina:       "6f85f19c69fbfcae884d460d244916175617a216e7c62f7f168d0dfdf627dcb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19034fa9f61f64b47f2719300ee381af5a293c1fe987622403a626d311aa0267"
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
