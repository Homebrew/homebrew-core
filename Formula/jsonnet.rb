class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.8.8.tar.gz"
  sha256 "668f4ffe1796d22902a485e0c383c1e149dcf7b5364c1bd79e48d8a62b4943b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e398400d16ad859db77f6c0f5150369fa355c3e50d47971cc339292ef5c15b5" => :el_capitan
    sha256 "c1193f9c7e550643f90b3e18708287424430729e4ff266ec47dcd78d48e4794a" => :yosemite
    sha256 "9de0592ed42f1af11a850a3297225b457f72d03428bc37cb33da1cbb95e15fc7" => :mavericks
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
