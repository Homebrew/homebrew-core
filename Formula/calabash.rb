class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.4.1-100/xmlcalabash-1.4.1-100.zip"
  sha256 "a79b0fb8775b3c34ca5e940b0b7eda6ce60dc1f27f6fc6aeb38178a944563700"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0cac82856118a0e1ca87f6c9ee57ea409fa4b254847971b87825e975ff7d40b2"
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
