class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.16.0.tar.gz"
  sha256 "fa1a4047942797b7c4ed39718a20d63d1b98725fb5cf563efbc1ecca3375426f"
  license "Apache-2.0"
  head "https://github.com/google/jsonnet.git"

  livecheck do
    url "https://github.com/google/jsonnet/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "af01487239fc6947ef6c27d9b4b18772d2b7773393d7e48704001bf09d380e5b" => :catalina
    sha256 "2255443d01048798797696161de2ddf435565348d7a246647a37b5ec0919dc2b" => :mojave
    sha256 "7cc0ca007b2d56160e93437779f7214f44caef1a76b0647c911b1ca6ac6ab4c5" => :high_sierra
  end

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
    bin.install "jsonnetfmt"
  end

  test do
    (testpath/"example.jsonnet").write <<~EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = {
      "person1" => {
        "name"    => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name"    => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
