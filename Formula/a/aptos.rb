class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/", browsed: "2026-09-05"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v9.5.1.tar.gz"
  sha256 "b879c442d065801aa086ab60817614c0fb0c469ba70ebd98a5e1c2392f0ef14b"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17b35e1ac627921fbf8be39799b807ed5e2f33e1c1aa3633dfcaf6ffe7cdb0ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5544019d04c35797fcfb8b2d87b8842f950bcdf0b59161b78d319d639876fdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f943918d7d229a5098cd87196b21e76965585539a2de7bc61ce72281a6beabd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c11cb840fc37e7e55d1f8797ddab0dcc8410ef2f23d3ef8c0541330410285b0"
    sha256 cellar: :any,                 arm64_linux:   "96ca4ebf962464d4e273f24dc639f09f3555947858c41014b07201db0b7f2345"
    sha256 cellar: :any,                 x86_64_linux:  "e95a8478cd61aa956e761ef2bb3cdbdb0146d0329ab1c3d8ff702d3da85ce330"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"

    on_intel do
      depends_on "lld" => :build
    end
  end

  def install
    # Remove optimization to allow bottles to be run on our minimum supported CPUs
    inreplace ".cargo/config.toml", /,\s*"-C",\s*"target-cpu=x86-64-v3"/, ""

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"

    # stdout is not supported, so install manually
    %w[bash zsh fish powershell].each do |shell|
      system bin/"aptos", "config", "generate-shell-completions", "--shell", shell, "--output-file", "aptos.#{shell}"
    end
    bash_completion.install "aptos.bash" => "aptos"
    zsh_completion.install "aptos.zsh" => "_aptos"
    fish_completion.install "aptos.fish"
    pwsh_completion.install "aptos.powershell" => "_aptos.ps1"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
