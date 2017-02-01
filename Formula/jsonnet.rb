class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.9.2.tar.gz"
  sha256 "bf0006ddd1fb3c77faae356e6e83bfa4a92bcd9eef4723b5807c77a09e7ec97f"

  bottle do
    cellar :any_skip_relocation
    sha256 "9708a18db387ed5654e2b5c1b32987a2d561e88d3ae2f501a2a517d89f76543c" => :sierra
    sha256 "d752794a7a59c472439df67097ecead00fa3edcb5daa6653a9aadb76bb034bc6" => :el_capitan
    sha256 "489f718b55c53d40104ed0ff53e3b51cb1ff3a85b6006b8b978b7436dc9fd0ee" => :yosemite
  end

  needs :cxx11

  depends_on :macos => :mavericks

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
  end

  test do
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
    assert_equal expected_output, JSON.parse(output)
  end
end
