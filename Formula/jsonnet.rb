class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.9.0.tar.gz"
  sha256 "8e1473cc5225b99d626cba44b85177e34bf458112df164d8a6ecc9475608795d"

  bottle do
    cellar :any_skip_relocation
    sha256 "eeaa92759a002755344fab71c4f89cb908c35fd3f1255e1df1a192bdd65ff36b" => :sierra
    sha256 "17c8a6e47a691ae5d0a725c130109c465c6a71d9e0ae0fc9dc2f064862f8982e" => :el_capitan
    sha256 "54263961fd65d09db63aa6f35e194619d1dd1c308794af1b3ca6da287812f052" => :yosemite
  end

  needs :cxx11

  depends_on :macos => :mavericks

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
  end

  test do
    require "utils/json"

    (testpath/"example.jsonnet").write <<-EOS
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
    assert_equal expected_output, Utils::JSON.load(output)
  end
end
