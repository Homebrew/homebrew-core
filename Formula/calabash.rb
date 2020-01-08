class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.1.24-98/xmlcalabash-1.1.24-98.zip"
  sha256 "e80bca50cf7e32bf4fd3ae4c2e426b781224fc726ecdb55f9251c2be0ee53a64"

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
