class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/refs/tags/v10.5.1.tar.gz"
  sha256 "3ea70c258d3390a601b436b6f4c545e3a944ff3de44c8ee5542c05588e337032"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f890070c20c3cb5d726ed6b7cbeeadd29505176f9372adec55a6b728c398a0b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a8a3caebc8dca7b51b8675ef4d37b5bd1e0baae49c5a32c6e1c44fb904e18f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8e6f1a670e413c9de8e0c199029c99eb95eb4edb396b371fc6ada8278601977"
    sha256 cellar: :any,                 arm64_linux:       "8479427bd0de10860e5d6a67d4752b5ca04c57f621c70509fcb8187163ff0a8b"
    sha256 cellar: :any,                 x86_64_linux:      "aa77e6abdd5660d9be636f50189958d64a0e6f1b1c27f7f1c8dc1255cb2a3210"
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
