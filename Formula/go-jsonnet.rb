class GoJsonnet < Formula
  desc "Go implemention of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/v0.16.0.tar.gz"
  sha256 "8ca930c892d34a119c1970431d159000321fe323734f06a1253bd78fc3625b84"
  license "Apache-2.0"
  head "https://github.com/google/go-jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c476a536e168be0cf65a7850c05563c5363356774057bd9cfc8aa11cb0e0df6" => :catalina
    sha256 "6dda575e3b152664a76776a23ceec61a471fc0baedbb4062e784d4f917a76b15" => :mojave
    sha256 "3f98a99da047fabc9a1fee8b32585c86f2e370a6a278e7d27cef8f7a050006c5" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "jsonnet", because: "both install binaries with the same name"

  def install
    system "go", "build", "-o", bin/"jsonnet", "./cmd/jsonnet"
    system "go", "build", "-o", bin/"jsonnetfmt", "./cmd/jsonnetfmt"
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
