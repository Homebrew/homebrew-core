class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.10.0.tar.gz"
  sha256 "524b15ab7780951683237061bc675313fc95942e7164f59a7ad2d1c46341c108"

  bottle do
    cellar :any_skip_relocation
    sha256 "b332f6e4ea839f7e62b083202641fb73e850cb850d7f42b42430ef76692cb6fd" => :high_sierra
    sha256 "0827b6713626eab7f3bdccd2092d42c93fa532b52a4fd611d3a54c37f1f39205" => :sierra
    sha256 "7996bc4f204b8e7fc7cc0b3759cf78f2ad8b5f59a4c9f71c733ee61228d28a33" => :el_capitan
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
