class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.8.9.tar.gz"
  sha256 "88154d91fd925b6f5fccc7b41d4662297d2d61eadde836b3b74e56b209784015"

  bottle do
    cellar :any_skip_relocation
    sha256 "514ae0343883f63d5f39ec27ceb38872a23de1c9d3ffc6ad23de9e0e07b74ed3" => :el_capitan
    sha256 "e36044b2d7a55e276d28fdc061000d2ca2cd82dd5eccbee4c6a5198f2c0ae25e" => :yosemite
    sha256 "e88d88f1c4b971dd91178e26158d792a1611623543a7297ccf458bdedcf4a5c8" => :mavericks
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
