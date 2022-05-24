class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/3.7.2/dita-ot-3.7.2.zip"
  sha256 "4f65e9cc471758d72c5b1640ea2c2d9875c5cb82780c500c97bf244dd20e5bd9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d03822da60bdbd56137a25ae5786786d3108cff223160c3bc5df3fcdb37572b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d03822da60bdbd56137a25ae5786786d3108cff223160c3bc5df3fcdb37572b3"
    sha256 cellar: :any_skip_relocation, monterey:       "18ff943e1c93d3bd4aa8b5885306edeff45d0874923f2e16d2a32574aa28e775"
    sha256 cellar: :any_skip_relocation, big_sur:        "18ff943e1c93d3bd4aa8b5885306edeff45d0874923f2e16d2a32574aa28e775"
    sha256 cellar: :any_skip_relocation, catalina:       "18ff943e1c93d3bd4aa8b5885306edeff45d0874923f2e16d2a32574aa28e775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9b9376dc798b7301a2547f39ede85ba33a6daff626b83838d3ddcd5702f823d"
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
