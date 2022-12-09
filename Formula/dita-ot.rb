class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.0.1/dita-ot-4.0.1.zip"
  sha256 "a2f5ecd58b6f069cb5e45444e44e1a32acd51819921065f655667467cac2f3a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2361421d2b853418338733a22c50d4f9e7507057bf79285390f60813231af1b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2361421d2b853418338733a22c50d4f9e7507057bf79285390f60813231af1b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2361421d2b853418338733a22c50d4f9e7507057bf79285390f60813231af1b9"
    sha256 cellar: :any_skip_relocation, ventura:        "2b793e6f1f7505dfd698491511a90485cfdc9ae25c061c7f447b0b42966f3128"
    sha256 cellar: :any_skip_relocation, monterey:       "2b793e6f1f7505dfd698491511a90485cfdc9ae25c061c7f447b0b42966f3128"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b793e6f1f7505dfd698491511a90485cfdc9ae25c061c7f447b0b42966f3128"
    sha256 cellar: :any_skip_relocation, catalina:       "2b793e6f1f7505dfd698491511a90485cfdc9ae25c061c7f447b0b42966f3128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "103b12c9d4aee01b67f9db36f0751037186a37bffbbadbec1e81bc9b8bc67916"
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
