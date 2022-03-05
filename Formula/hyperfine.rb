class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.13.0.tar.gz"
  sha256 "6e57c8e51962dd24a283ab46dde6fe306da772f4ef9bad86f8c89ac3a499c87e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb094b1970220105faeb1fc7196e5bfdca61fb061ec494383887c782bbe886b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d24a5a1eca94b1559dc0703e9691ce73798af668dcfa0242603c73e7ab6f851"
    sha256 cellar: :any_skip_relocation, monterey:       "16d940f6bfb8d398c131765df6feaa3da2527b4db09a938961f1b71764e8e872"
    sha256 cellar: :any_skip_relocation, big_sur:        "00afb7b8800cbda436e644d81d6fd507e6fc320d31e36f6fbf4eb00959ee8efa"
    sha256 cellar: :any_skip_relocation, catalina:       "0c75bcc04f21e239b71a8a37b5f92e23b714253478b7d132458204932d9ab3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6718cdf9aa2cec11e42b88ea8175e92bee9fc1977ec84db1880577772d072934"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/hyperfine.1"
    bash_completion.install "hyperfine.bash"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end
