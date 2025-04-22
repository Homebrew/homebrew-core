class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "d1c782a54b9ebcdc1dedf8356a25ee11e11099a664a7d9413fdd3742138fa140"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acf0ce7620aa8b6c3e1f1b755d8fb1a89445b4293935c3d5a96ea3f8f193ec22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76a4b9596447f7c86d96de9bd7d9312eceee745509f9bea470bc32fafe0b97b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1113b8769a5054fd790e5de5cd95089ef500bcce78694f6263be6f25d521f0c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b79040d510fe182211e539164cfa633858ec983b9ae33d62a8f028a18d01a0e"
    sha256 cellar: :any_skip_relocation, ventura:       "f738c61291419374ec425df822cef3486cc86504d42d7a995301b13485303b60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44571f44266cd6388c86a22fceb6b947d39fe4abebaad9094cc10c163ddea8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c758dccd2d2f5fbd7f6a2ae6971534ac1cb0c6f0f6e83ff21741798326c98b52"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args

    bash_completion.install "hyperfine.bash" => "hyperfine"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
    man1.install "doc/hyperfine.1"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end
