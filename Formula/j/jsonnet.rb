class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "5914b9904d97efa662d919519cef1a14e4132bfddddaeed8b061b4a8af628f8d"
  license "Apache-2.0"
  head "https://github.com/google/jsonnet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66a5ccefe36864188b76ab72a876281e0f84aa043d340763b746ac2affceae86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ba072f6520c7d86667c2e69bd4d2aad4c0233d5162fd7c69fdb232d5c821986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "821dcfaebdfc20b7af5cb518b7a38108abab34987eec98ce741f8eaf1a4eed5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "468b1b3a4f75fbf73b33033b143f64cb87f53989f7475de2b08968d563b0c1e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "017b5d0b4e17d47c2ebad8a34e976eb2e634cef232af744a329aea5c6baa4bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2867f7ad19c7c37f6efc5e53b4695e2b8352bb7d10f6f6cb25bbb80a35964890"
  end

  conflicts_with "go-jsonnet", because: "both install binaries with the same name"

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
    bin.install "jsonnetfmt"
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
