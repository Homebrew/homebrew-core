class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/v0.17.0.tar.gz"
  sha256 "85e4b49a25a8fc76fcaf84c2d4b8a668e403b05a1a668134a7b08c9206ccfa5c"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3aaebb502a7310977efc1064a19e19239a5fb6f7269fe51c0a00ad86aac839c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "20d84ae8fc4c85f1960c92eade9ef7113ccce4438568ca9ba92b2fb14dc7dccb"
    sha256 cellar: :any_skip_relocation, catalina:      "1f47c8fbc694e82e1bcb0ca9bd829a8c919a8429c9077b14da8012d72d325579"
    sha256 cellar: :any_skip_relocation, mojave:        "5835770e44f7ea85c665225c9e2036c0a0ca8ea1fe070657b6068c20a567e412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d839b3bf132d4d68ee9d55fb984a67e6bec648efe887e38d1cba8404708a8f5"
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
