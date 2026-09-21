class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/refs/tags/v10.5.0.tar.gz"
  sha256 "e6d9e90730bf316101691e49d59cc02565278dc3779d33a77423801569484851"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bc544a1b6eaaddc82dd5d831a86d16427746e004601e516b8fac45a5f35a28a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8ccfce40967859000e4512fd37b8f0ee178572f3f131d6d6fa37faac4205f16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72ac30ac960c40f8bf5746148d94a21f3a14dcb78374108fc5416f29a7a9b146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "d08e1b33c3b39c4ad55a0213c65074ea2c75a7af4559ddfe26f50de361d3f0ac"
    sha256 cellar: :any_skip_relocation, sonoma:            "c57f68964c5f724c61ab92d691e84d82123fe258e69d416bca3d58d403eeb73a"
    sha256 cellar: :any,                 arm64_linux:       "fb686c0ddb7761d127084974ca01d9db3a6e14a2e8db50feb709434eebaf6f59"
    sha256 cellar: :any,                 x86_64_linux:      "651c4799f3f39ff04634016107683fdc333332594a926bdd5623b853855901fd"
  end

  depends_on "rust" => :build

  conflicts_with "fdclone", because: "both install `fd` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
