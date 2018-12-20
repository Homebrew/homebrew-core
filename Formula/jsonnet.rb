class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.12.1.tar.gz"
  sha256 "257c6de988f746cc90486d9d0fbd49826832b7a2f0dbdb60a515cc8a2596c950"
  head "https://github.com/google/jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8f80003eeda0e6c021ef61e103a6925e46c73527a54672c9d529b4240cd7f43" => :mojave
    sha256 "692a24cecfb0b51c0031b08c1dc01b77c0ccc03761888b48e5d9e52f605aa46c" => :high_sierra
    sha256 "790202f72a1e5b63dc1b4fe6107111644d4a54b88cc95ccf11f4507b6efcf52d" => :sierra
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
