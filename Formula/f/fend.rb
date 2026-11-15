class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.5.9.tar.gz"
  sha256 "3622b09d197d4be374880f3f97256633d0481e7a3c7da2f69f2cb5141aac1721"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a18235fa7f6de8f7f38d90e477147f24dfc372272fd833666b168833ffa760d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23fe7e45d34f460baa763d2424bcc1d319c684881491720d89d21d5951f53f5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d067d51b05963bc38be4c60133ead918e7dc1d5df4a386104f4729784ad001cb"
    sha256 cellar: :any,                 arm64_linux:       "0293e2dfad04512cf43e0b02608989c95c21b3efdb08692851f5527f77d7f9e0"
    sha256 cellar: :any,                 x86_64_linux:      "06e6725a3de6b1f8ed89be982d895aea9d15eef0839a1efea41f5e1cac3586b4"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli", features: "native-tls")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
