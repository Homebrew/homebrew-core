class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-12-29T06-52-55Z",
      revision: "05c3ae8716dbe06d512ecff963c422942f4d71cd"
  version "20211229065255"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b94d17d52bac0b2623c9db606985df8951c09c9536f492f689fd880234fd19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f86911116e80f6b6a62eb89ed263917bd25b34b66424a6347ae426fc8c8e301"
    sha256 cellar: :any_skip_relocation, monterey:       "e5179abe14e14e51e42cbbbba91aeb847c75ea19068af3acbb80519f1d02ce55"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1ede1718906f95d2c26a4d9e2fedddebd1d883765ffc2014cf157d1278a5e15"
    sha256 cellar: :any_skip_relocation, catalina:       "09d09ace12da9c0d56893e5e7577297006cbc7501d10e46c7542c523b5be8435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "387bc8f2c0d8cb3245b342eaf0e7db76a283767920fa8f7e09d8fc857c4433fc"
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
