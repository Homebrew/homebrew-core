class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.2.2/dita-ot-4.2.2.zip"
  sha256 "9bccdd4b11f707a402608e4455e1d46d811d0c73d97355dbc2928f3761905cc3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f808c656fcf47a0389b0e203dde794de3429b81bed95a9126b209c82682d2bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f808c656fcf47a0389b0e203dde794de3429b81bed95a9126b209c82682d2bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f808c656fcf47a0389b0e203dde794de3429b81bed95a9126b209c82682d2bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b6e99e260c318d62c1e0ce13959a300a3f25608608b9d2eecfaaba2c57ce489"
    sha256 cellar: :any_skip_relocation, ventura:        "9b6e99e260c318d62c1e0ce13959a300a3f25608608b9d2eecfaaba2c57ce489"
    sha256 cellar: :any_skip_relocation, monterey:       "9b6e99e260c318d62c1e0ce13959a300a3f25608608b9d2eecfaaba2c57ce489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2444063da5908dcf375322e5b9a6636bf7cf0c59e7f5262c46e91ef118e45325"
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
