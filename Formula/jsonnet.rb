class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.9.5.tar.gz"
  sha256 "f504b6079882a18f0e8304f9e230f04eff70c2f0fb94a18fc26cbf989c7d838b"

  bottle do
    cellar :any_skip_relocation
    sha256 "82cf66710a2eddf18c37075d5e411d1acc4e5b4edb7b824fd44f69c23550e947" => :high_sierra
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
