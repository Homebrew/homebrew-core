class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "d2e5273a5b3f198998413dc1744665167732f83040451a0f8ef58224eaf52bf9"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff145c188aeffb8334cfecac84ff752fe48eb62143738cf8ee864a092a798fb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71327f4795ada20de95fcbc6b6089c6185bc666e932326a9061877b5f80a3b52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e64fd9cf3ab2840a487bd8a9ddd4829b78fb2e71a52c516d54323b88cc245ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "884973a8b4fd751d5011cca817d8324d68491a53d175ce804841af345edd212d"
    sha256 cellar: :any,                 arm64_linux:   "85aa2d1e2b3c59691af7592c0fbff53bac55cde3385780dd3fc5287b4cd270da"
    sha256 cellar: :any,                 x86_64_linux:  "c63aa66739917f9b44e314e05c941b943825f95f17f34c5f381959199a929212"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
