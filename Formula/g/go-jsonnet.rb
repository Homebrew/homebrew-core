class GoJsonnet < Formula
  desc "Go implementation of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "ee7aa004e78fb49608bcf28142a7494dc204a07cc07d323dd2cff3d97298c696"
  license "Apache-2.0"
  head "https://github.com/google/go-jsonnet.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71970a3746e1df0623b04394d223a551253fc3fa2af026885d976f85df469def"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da0bff35201dd30f0992b3a4d2be4dcf4081a8ece97e8841cdc56202ce9f5f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1da0bff35201dd30f0992b3a4d2be4dcf4081a8ece97e8841cdc56202ce9f5f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1da0bff35201dd30f0992b3a4d2be4dcf4081a8ece97e8841cdc56202ce9f5f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "857205b6b5af2d4cbf762b4479612ceb5cb330d89c4825a7519f216a39fd61f6"
    sha256 cellar: :any_skip_relocation, ventura:       "857205b6b5af2d4cbf762b4479612ceb5cb330d89c4825a7519f216a39fd61f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd6fefa551f11430c771c4f9bc581a08b0ca166eb1caa02d52cfdae71e4e0065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f561d3294310d773a7f59d4eeb506aca0a86b510a654965096bbebe041c87032"
  end

  depends_on "go" => :build

  conflicts_with "jsonnet", because: "both install binaries with the same name"

  def install
    ldflags = "-s -w"

    system "go", "build", *std_go_args(ldflags:, output: bin/"jsonnet"), "./cmd/jsonnet"
    system "go", "build", *std_go_args(ldflags:, output: bin/"jsonnetfmt"), "./cmd/jsonnetfmt"
    system "go", "build", *std_go_args(ldflags:, output: bin/"jsonnet-lint"), "./cmd/jsonnet-lint"
    system "go", "build", *std_go_args(ldflags:, output: bin/"jsonnet-deps"), "./cmd/jsonnet-deps"
  end

  test do
    (testpath/"example.jsonnet").write <<~JSONNET
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    JSONNET

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
