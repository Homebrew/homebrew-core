class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.3.2-100/xmlcalabash-1.3.2-100.zip"
  sha256 "a445405c30be8441b687442ad93578e909e16bc895eb05b14830629014eaa07f"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ab946c9278a65a4fb2af46869d933ca372e8c6ce9ce73ab85326816f31d92fa"
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
