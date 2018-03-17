class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.10.0.tar.gz"
  sha256 "524b15ab7780951683237061bc675313fc95942e7164f59a7ad2d1c46341c108"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1e7b24a01601304ee1a54402019d27e9a61ba40d4d8cc7ffff506784f4bbec5" => :high_sierra
    sha256 "44fff61b8492dc57f385eac3808a3adbfa302caa12c81aae096fe339a5a06257" => :sierra
    sha256 "5b9d9bb335bc85c73f0ec88add5fb9678aa65593c586b3a9ec6f7e4cd82168fb" => :el_capitan
  end

  needs :cxx11

  depends_on :macos => :mavericks

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
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
        "name" => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name" => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
