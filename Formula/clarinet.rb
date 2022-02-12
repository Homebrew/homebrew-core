class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.26.0",
      revision: "16f28680031185d64c781b6770177483268e1676"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb18de77aa8241f07f95e4ae76ad341c610d6e2294033097bb54564a5ccd3d70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "164b419cb6c8b43c7126cb005db06158152d7b528b9c6eb5ae47d19e1fb2d8a1"
    sha256 cellar: :any_skip_relocation, monterey:       "1020566c9e26c55ef43fa039222b9b3e7ce99ce288fe16b738e887d0eb1d95d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7038772b146e0f353961af735d5715085f2efbea07b118f5ec7a7c90f061702"
    sha256 cellar: :any_skip_relocation, catalina:       "3e3d60d2b5991c76d4fa78aa8aa85527adaba4816251dbc27bb6e7e2042e84b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccece07c37ea02b3ec0f68e4cabeefc2d6ddfb3114a131f00cc540c2c36386b5"
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
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
