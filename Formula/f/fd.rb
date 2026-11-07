class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/refs/tags/v10.5.2.tar.gz"
  sha256 "8991b6504cac33c00528050622dfe3f2a0db1be1a6faf99f69b46d1a8f737dc5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e03e492b6c6ace144f79e6397b91fff0138b0657fb4c2332ddabe1fda3da5912"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8696259e252df9394e6f06488fde396b26caa14b4475e4c19074147031c99db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c22e0e1a76286468c5a8fe2c3e0898dd7bfa127d66374d8bba5368b77dfed792"
    sha256 cellar: :any,                 arm64_linux:       "8c27ae96674f38c491cb6c5c04dd284bff98161c061c96469ab0542008d19bcd"
    sha256 cellar: :any,                 x86_64_linux:      "56444cb4d1d010cf346dbe8a5b2d6f4140208a6467aedb736f37d15f874943c1"
  end

  depends_on "rust" => :build

  conflicts_with "fdclone", because: "both install `fd` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["JEMALLOC_SYS_WITH_LG_PAGE"] = "16" if Hardware::CPU.arm? && OS.linux?
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish, :pwsh])
    zsh_completion.install "contrib/completion/_fd"
    man1.install "doc/fd.1"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
