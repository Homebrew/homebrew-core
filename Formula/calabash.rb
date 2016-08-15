class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "http://xmlcalabash.com"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.1.11-96/xmlcalabash-1.1.11-96.zip"
  sha256 "6eba2a820dfbad5ddfd8b3b34ee60201c5871f99e5257e6cda8f0afdccbdc591"

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
