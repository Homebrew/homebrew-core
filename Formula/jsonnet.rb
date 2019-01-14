class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.12.1.tar.gz"
  sha256 "257c6de988f746cc90486d9d0fbd49826832b7a2f0dbdb60a515cc8a2596c950"
  head "https://github.com/google/jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f5622fe20d111af4167d68e5773e03e670f8ab6d56b8c0baf04ef5290a97006" => :mojave
    sha256 "5d47df81ca6ce733af80dd41117066b46de571eec2079a7efe5cb9e52176a1b2" => :high_sierra
    sha256 "5389ab6d3c9fea659e544058e04ec9cf215c0ad6dca1ed56a6188c3becfbb53c" => :sierra
  end

  depends_on :macos => :mavericks

  needs :cxx11

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
