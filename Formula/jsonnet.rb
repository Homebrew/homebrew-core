class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.14.0.tar.gz"
  sha256 "7f41cdc4cb366cfc1de3aada926a2f7e640ef025887eb05cdaf8342d6e4e088b"
  head "https://github.com/google/jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34027529c69b14c27c5a903bd1ee6c6fc368b3d9115b4c63e7cb93ed1e64a2e3" => :catalina
    sha256 "51c48fabc272d0fd1affde0bc7025b067913067e68fe5b142815d92270b151a0" => :mojave
    sha256 "5e90257ebfb7be1662553482275a2507a858642659703af00ee339e125edc810" => :high_sierra
    sha256 "3bcb8c5591acc3566d1ed94d2e21b9988d1622e203de62c5fe110996b84564ca" => :sierra
  end

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
    bin.install "jsonnetfmt"
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
