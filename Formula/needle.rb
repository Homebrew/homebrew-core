class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      tag:      "v0.16.2.1",
      revision: "86a5d15ed2e1ad34403f354477d365221d94f318"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bb31df891370ccea3d3d7b88094e6909d223c9ed609889ee0c136f8812b414b" => :catalina
    sha256 "ea9e38d739acc83ca9a58ba10aef72456e73f22e790462f243192db7aa0a814d" => :mojave
  end

  depends_on xcode: ["11.3", :build]
  depends_on xcode: "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
