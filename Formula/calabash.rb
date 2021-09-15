class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.3.2-100/xmlcalabash-1.3.2-100.zip"
  sha256 "a445405c30be8441b687442ad93578e909e16bc895eb05b14830629014eaa07f"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ef59636fffaf99c2603ce32dcc200840889204fbdf8fdd5b54fd5efe0bb692d"
  end

  depends_on "openjdk"
  depends_on "saxon"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"xmlcalabash-#{version}.jar", "calabash", "-Xmx1024m"
  end

  test do
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "#{bin}/calabash", "#{libexec}/xpl/pipe.xpl"
  end
end
