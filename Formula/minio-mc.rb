class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-02-14T04-28-06Z",
      revision: "7672841f8c58264000758e96d3870caa0029dabf"
  version "20210214042806"
  license "Apache-2.0"
  head "https://github.com/minio/mc.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "92320b84d5d04bb8b767ce705fa8dda187e865fc76fbd40d8251befd477a6441"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f157c0a8dbd19067a67f7885b5e57330dd962780937a51b2ea1b3f080cb7240"
    sha256 cellar: :any_skip_relocation, catalina:      "9574cb00dd3729541b36be9c66a618970360bc633de9be44322d2c2703e2b08a"
    sha256 cellar: :any_skip_relocation, mojave:        "45cfba37673ffe08f68c613519e0aa9c15c60d3b2fd4ddf08ab18b061697018e"
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
