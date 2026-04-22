class GoJsonnet < Formula
  desc "Go implementation of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "9c463043a05c1e833c57136521e808ee8df192131f00c636235a2b54823d8c4c"
  license "Apache-2.0"
  head "https://github.com/google/go-jsonnet.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85de63336520c4bff8ac427d7669521c77497a3e67e82a49b41c82de33feb6bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85de63336520c4bff8ac427d7669521c77497a3e67e82a49b41c82de33feb6bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85de63336520c4bff8ac427d7669521c77497a3e67e82a49b41c82de33feb6bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac32711401c962f3781e5cef03fdc233dc8a2cc983fda610329bc5adde641bb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "408dd089b37267bdc16c7b10ce2269dca3eca7adcd71e22b1ac9219142356323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b41611f2b1ea2b8cdefbc358239d10c9a7d0f6f0db19d82bb74ee11e70c968"
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
