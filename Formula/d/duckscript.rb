class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/refs/tags/v0.9.4-01.tar.gz"
  version "0.9.4"
  sha256 "f341b81724e2f6bc2ea824155f5aea38a17d3c9a79d274aa2aba96c3890695d1"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b987b8107ace0db8d7cd3761d0808fc627d4bad33fc866220e7bb411c01355f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d3cefd642d7aeff32073fb23cb0f1505de36dd46d15bdf0b1c72bf6f324e00a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d47f018e1f6453ae50ab10fe59be44630b66c097f0689badf43d62b793b7ea8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4030501fa35a536b72fecd0dc305bf195d9ae96bbf4efa8a159191cf9ae0892"
    sha256 cellar: :any_skip_relocation, ventura:       "9e574c5420c6c165c284e64a7430baba8f5b52e3750a6aea459725327e021b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b9cd4f260f3acb474fea9acbc4ae2dddd3f2aef3efd7a2d72d7311877c0721a"
  end

  depends_on "rust" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  conflicts_with "duck", because: "both install `duck` binaries"

  def install
    system "cargo", "install", "--features", "tls-native", *std_cargo_args(path: "duckscript_cli")
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
