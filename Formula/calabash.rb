class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "http://xmlcalabash.com"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.1.16-98/xmlcalabash-1.1.16-98.zip"
  sha256 "3672a0422b3207c34c3bf0218a858a52da62c087294c12057cca968f5470f100"

  bottle :unneeded

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
