class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.5.3-110/xmlcalabash-1.5.3-110.zip"
  sha256 "e599484bc95b1dc2086a04c4be24e15da9eada8139b3e6a35d3636e2a8be18d7"
  license any_of: ["GPL-2.0-only", "CDDL-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8facaa4f43d14c528c7efc1c3b66fd61fe8f4af01022f82e0a7aa72082f844dd"
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
