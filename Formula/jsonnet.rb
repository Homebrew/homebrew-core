class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.14.0.tar.gz"
  sha256 "7f41cdc4cb366cfc1de3aada926a2f7e640ef025887eb05cdaf8342d6e4e088b"
  head "https://github.com/google/jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e485bd544c0a43cc82f7d36ad3927261c3b6985f041d15f9cc6ce801297d193e" => :mojave
    sha256 "d4067225c401c1a6ccd83809edd2c6dc3ca1342a3fc891f0c750029b8c942a07" => :high_sierra
    sha256 "0d0cb6e6051c492b82b83e9f78dbdc3d42c2d69cbedf050a98c23bcb7e8eb6ad" => :sierra
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
