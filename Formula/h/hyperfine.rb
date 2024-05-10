class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "fea7b92922117ed04b9c84bb9998026264346768804f66baa40743c5528bed6b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1939fbf7cb48e03cc1034d96381a28f387f9d64392bd95d654c5b3380553747d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08f05d443950d5d65314757434b87ad58c1919c01fe101c40db28a5123a7346b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6aa2641cf76179286d0534d310960e08172d72a70b0f517713497a88eac75e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dac9d926a311e7a089490abfd1ee6bb8589df543fb303708df69760b35ccefc"
    sha256 cellar: :any_skip_relocation, ventura:        "6968c0845b38aef0ef8a8520beb2f4ff76d8af3e3ed4d0d21cef34c49c506540"
    sha256 cellar: :any_skip_relocation, monterey:       "3136c0d2e75850f036627794044ed25d6a7bb9b82e9e2e6cdd056c543fedf6d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18a874acbfd88d21dd0b279e4810711b79bc42481c5e2a749b73c98d281e80dc"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/hyperfine.1"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https://github.com/clap-rs/clap/issues/5190
    (share/"bash-completion/completions").install "hyperfine.bash" => "hyperfine"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end
