class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.9.4.tar.gz"
  sha256 "7fe24208ff97cb563fee4f6a67a4dd831622841d345b2549b47e1243295f5ec3"

  bottle do
    cellar :any_skip_relocation
    sha256 "1075760e65f5fc12fb4c1453b5cb77e78ae89f7c8de70fac42dd9d355fde256c" => :sierra
    sha256 "40d74203b43bd9b8b9002bcf63d3d49c0f8eb76f805a55b2dea71dabd4429d1a" => :el_capitan
    sha256 "d92459fc74c8f0ccd31f4a76fbf68f97a8668bafc405eb704388fbc565422e9c" => :yosemite
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
