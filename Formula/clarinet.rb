class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.19.1",
      revision: "25e604ec2397667d171f5d2bde2cd16e9f9b7774"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9422400535a1e93152814a11815e5fdb2e2ef0e97cd68a63d691c9139c33c62e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbff02f9bd9fecfffb5ee438674f783ea30c8734e43f6152198271b52c881ad1"
    sha256 cellar: :any_skip_relocation, monterey:       "06a28ffb740ad85093f558c97de6e4896482dd84547a4f64612be61531e545f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea0ff0ee0ee1807fa8d121889c826b66893fdaf81933933880ee1e27bfecb08c"
    sha256 cellar: :any_skip_relocation, catalina:       "a1a092d6d8b3691d260616fcf186700253b6aeef93a2475789e6374ffe110f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a40c9ea9f5743ce090759c27809f74ce820549f90a511cee978d643c46478ee0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"clarinet", "new", "test-project"
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
