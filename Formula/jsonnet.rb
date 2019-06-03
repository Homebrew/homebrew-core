class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.13.0.tar.gz"
  sha256 "f6f0c4ea333f3423f1a7237a8a107c589354c38be8a2a438198f9f7c69b77596"
  head "https://github.com/google/jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f5622fe20d111af4167d68e5773e03e670f8ab6d56b8c0baf04ef5290a97006" => :mojave
    sha256 "5d47df81ca6ce733af80dd41117066b46de571eec2079a7efe5cb9e52176a1b2" => :high_sierra
    sha256 "5389ab6d3c9fea659e544058e04ec9cf215c0ad6dca1ed56a6188c3becfbb53c" => :sierra
  end

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
