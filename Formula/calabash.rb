class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.5.6-120/xmlcalabash-1.5.6-120.zip"
  sha256 "22b144edd2dc6901b04fd540cea3cff539b4d8d1bb55794b59d40a8bcec72535"
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
    sha256 cellar: :any_skip_relocation, all: "8013c68877bb6698bf8690e4e845344a114d3d33663b6a2647672764effef5bf"
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
