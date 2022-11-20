class GoJsonnet < Formula
  desc "Go implementation of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/v0.19.1.tar.gz"
  sha256 "7ff57d4d11d8e7a91114acb4506326226ae4ed1954e90d68aeb88b33c35c5b71"
  license "Apache-2.0"
  head "https://github.com/google/go-jsonnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7f8dfba1c4375efe666659690858fa3158dce7d30a6d75ff92a758187ea955e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f887f81f923d669cc0008c821d337da78db1d82062bcd66929cc897fe8eea9ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "086c86fb80853faa49d5483f506a6d8250013c8fea9df75776ee69caad76fab2"
    sha256 cellar: :any_skip_relocation, ventura:        "507d42c01d892c04ddb056aa76a7833de6f29e92fc27c9ad4a937eea25c2acf4"
    sha256 cellar: :any_skip_relocation, monterey:       "2d75ab2e8ad3830574b7bad0609816403a6ef9a7f5959de37b2ab683598c7b47"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d129795c442bc6126bafa740e008b9ad7fd6ad0a2d544af3cb21bb9c4c3ab51"
    sha256 cellar: :any_skip_relocation, catalina:       "7d654505048776d7280f994863d32673684c68396f9d13f1d250eb720404413c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "077d5fce549320657feeec94738fae8608d72744d2bba530980a27a224f2089e"
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
