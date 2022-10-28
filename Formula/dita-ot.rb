class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/3.7.4/dita-ot-3.7.4.zip"
  sha256 "2eb8289a34a2f4c1ebb57381d37a6207b377542f09babc1e0a82e7eb65a3b0ae"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54bd3d7f34456a7a96537530523b880179ca3ae791198e719038348753faf011"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54bd3d7f34456a7a96537530523b880179ca3ae791198e719038348753faf011"
    sha256 cellar: :any_skip_relocation, monterey:       "85290df925d710ddbd9006fd20c208781b0c20ee1576ffb070887ff425aad1f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "85290df925d710ddbd9006fd20c208781b0c20ee1576ffb070887ff425aad1f1"
    sha256 cellar: :any_skip_relocation, catalina:       "85290df925d710ddbd9006fd20c208781b0c20ee1576ffb070887ff425aad1f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3350a456fec1a131375aa50c053d83feaa9736b8cbbbef733c6b89692cc76c47"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat", "config/env.bat", "startcmd.*"]
    libexec.install Dir["*"]
    (bin/"dita").write_env_script libexec/"bin/dita", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"dita", "--input=#{libexec}/docsrc/site.ditamap",
           "--format=html5", "--output=#{testpath}/out"
    assert_predicate testpath/"out/index.html", :exist?
  end
end
