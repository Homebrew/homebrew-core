class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.26.1",
      revision: "c107d1bf1ae9a1d8765137561ecbcc327ed4aa47"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a92ab559d31fe75949b4acb647cdc7a87e88814fe034293ed18ffdb16fdab8a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f502351f14e73647dcb89747f9a4969b2097b7b17e3cfb25e68bb16130799f9"
    sha256 cellar: :any_skip_relocation, monterey:       "e8037e562ca04d6c07be1c0e580eb5c918bb6ef6c588af14a44cd40b30ce78a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6bc2fee565e49644433a93c2cda09d1fc121533b2f52f93bffd38f08fd3cd5f"
    sha256 cellar: :any_skip_relocation, catalina:       "ab19c9764153e6b62b636ab6878802c436dd8e30606347b54012fbc53b5cacf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3e3ecf859de6f598c3c4f04871f0a5d406fec35b8836b12466d397fcd6508a"
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
