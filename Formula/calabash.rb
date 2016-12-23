class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "http://xmlcalabash.com"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.1.15-97/xmlcalabash-1.1.15-97.zip"
  sha256 "e7ac420c3c4cf82c51b91e2e0dd11619b7a2d7e1594a2f730d519a369f9c17be"

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
