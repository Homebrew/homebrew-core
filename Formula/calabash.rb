class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.5.5-120/xmlcalabash-1.5.5-120.zip"
  sha256 "74fb7aed82944fdb0c814c5ebb534fd35083993de9d14afd6052d72563bba2e3"
  license any_of: ["GPL-2.0-only", "CDDL-1.0"]

  # According to ndw/xmlcalabash1#342, each release comes in "flavours" that
  # target different `saxon` versions. For example, 1.5.4-110 targets `saxon`
  # 11.x. Make sure the release we ship matches our `saxon` version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      saxon_suffix = "-#{Formula["saxon"].version.major}0"

      tags.map do |tag|
        version = tag[regex, 1]
        version.end_with?(saxon_suffix) ? version : nil
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e47f5c89d637416c72ab2fea895044a4f861dd1ccdb8b54496b8f94d59f4d0c4"
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
