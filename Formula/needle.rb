class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      tag:      "v0.16.2.2",
      revision: "1f8f8bce6a8b13106f8c679518ae96b03defc093"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bb31df891370ccea3d3d7b88094e6909d223c9ed609889ee0c136f8812b414b" => :catalina
    sha256 "ea9e38d739acc83ca9a58ba10aef72456e73f22e790462f243192db7aa0a814d" => :mojave
  end

  depends_on xcode: ["11.6", :build]
  depends_on xcode: "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
    bin.install "./Generator/bin/needle"
    libexec.install "./Generator/bin/lib_InternalSwiftSyntaxParser.dylib"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
