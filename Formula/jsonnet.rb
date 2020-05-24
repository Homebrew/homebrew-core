class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.16.0.tar.gz"
  sha256 "fa1a4047942797b7c4ed39718a20d63d1b98725fb5cf563efbc1ecca3375426f"
  head "https://github.com/google/jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "04af0ad884bb70f4867a8e7fa602195dc2c2a2c408f633b7579c28f772fadc8b" => :catalina
    sha256 "6741960348b032bd8bd5bc2d0f50008a649a955bf3449083ba425f7b2dafba48" => :mojave
    sha256 "435e203d80d12eb8ab887658b1b2f2c6f86860abd8e17134d4b4532f6401b632" => :high_sierra
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
