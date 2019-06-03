class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.13.0.tar.gz"
  sha256 "f6f0c4ea333f3423f1a7237a8a107c589354c38be8a2a438198f9f7c69b77596"
  head "https://github.com/google/jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c7cefbcbbe1ed4af8baab695587b240be856106a0c6063c9188d0d0000eeeb0" => :mojave
    sha256 "98bb2a729723d9267ee2a82871cacb384a37a1d4ceaa455a54b26e2bea0840cd" => :high_sierra
    sha256 "a553bc19d500681f4a97420bfc5d8dd79fc6b6262f15678b57c50851f69f102c" => :sierra
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
