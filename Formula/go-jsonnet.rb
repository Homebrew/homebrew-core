class GoJsonnet < Formula
  desc "Go implementation of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/v0.17.0.tar.gz"
  sha256 "4fd04d0c9e38572ef388d28ea6b1ac151b8a9a5026ff94e3a68bdbc18c4db38a"
  license "Apache-2.0"
  head "https://github.com/google/go-jsonnet.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a0ab911c3a8d77eb9c2cd9ef75e8027b19c5bbb442f5b7c6c6aea076a3a211c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93ba8dab3baf9865126d55705bcc357bf6a7d850e545ce43a5633748dcc95efb"
    sha256 cellar: :any_skip_relocation, monterey:       "7441633a7ab1a076ddf2b3fd519b9be5d81e8147e35affe0c53a35d09f46c040"
    sha256 cellar: :any_skip_relocation, big_sur:        "e79f3ad29f00746532ded81842fae95a980fba36980e8d6299aa7195eb0de0da"
    sha256 cellar: :any_skip_relocation, catalina:       "9e5ee375c84608de8566d017c9e8a0f9b3806c44156b56650918b78ffc0db9f9"
    sha256 cellar: :any_skip_relocation, mojave:         "83baf9f7af774dcdc0fb3484eef18c74d6ee20b2ca1e2c1b37f470c76d8d5d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3318e83a2961f88e5859e1a6700cd0ec09b2c93744460c968bfb1582ef204c2f"
  end

  depends_on "go" => :build

  conflicts_with "jsonnet", because: "both install binaries with the same name"

  def install
    system "go", "build", "-o", bin/"jsonnet", "./cmd/jsonnet"
    system "go", "build", "-o", bin/"jsonnetfmt", "./cmd/jsonnetfmt"
    system "go", "build", "-o", bin/"jsonnet-lint", "./cmd/jsonnet-lint"
    system "go", "build", "-o", bin/"jsonnet-deps", "./cmd/jsonnet-deps"
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
