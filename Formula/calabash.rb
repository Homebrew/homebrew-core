class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.3.0-100/xmlcalabash-1.3.0-100.zip"
  sha256 "75e4f9e6ed655a778a6cdf92feeb1e3f75a995bd5e623dfff7418e8c20823c45"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b35fca9a2745fa7bea9a71a9eec85071eba850af9d7df2c8132b81152f1ca6ce"
  end

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
