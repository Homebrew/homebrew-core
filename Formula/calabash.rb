class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.2.1-99/xmlcalabash-1.2.1-99.zip"
  sha256 "7dde0a5bd5dc2471d866efa3e4b5a4c456aa1acabe8e1b441abfd4b1c51f4279"

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
