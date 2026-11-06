class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "e33d53a71cd3c54537af21ffa935f60046a2b6e84708b533d7c5876f5ce5ffe5"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b4b58c454bdc8189d61593df4de97f66cc3694b71be80f1d17a7ef1ee2c6512"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc74cd0622e435aa531d6b6e24993d88e0187e854f2e16f8eb941d38fe6f5be4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63e2edec7f45b62c7e900cdbb31ff11566707ed9e3fdd190d5d27abe2397fc93"
    sha256 cellar: :any,                 arm64_linux:       "6148a6e415af69728884e56d3321cb27395bde9689374ddedd6f776aa9797bc7"
    sha256 cellar: :any,                 x86_64_linux:      "dc7d8046624da117abb2ad71481a7ac6893271622bbf258a74c95d8a5b332c4f"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")
    system "cargo", "install", *std_cargo_args(path: "juliaupgui")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
    assert_path_exists bin/"juliaupgui"
  end
end
