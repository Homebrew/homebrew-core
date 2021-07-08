class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  license "Apache-2.0"
  head "https://github.com/sharkdp/pastel.git"

  # Remove stable block on next release with merged patch
  stable do
    url "https://github.com/sharkdp/pastel/archive/v0.8.0.tar.gz"
    sha256 "603dc63d6aa261f159178dffeb389471a845c1a5d62187a275a3d33a66fe9a69"

    # Fix lexical-core build error on newer Rust with updated dependencies
    # Remove in the next release
    patch do
      url "https://github.com/sharkdp/pastel/commit/00fb2e5d52011903ddb5c33f4dfe1018d692ab3e.patch?full_index=1"
      sha256 "39dfc577e36645c693cf6d56e505d87d02450b313cdfc6a1acd59e1c5890247c"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5063fbbdfeae431e7522f8a66d48999e5ef0dc3d7dae922ffc088a227b90e1c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "fdae83eea8c1c098ddc551cbd18f010683b266fbffb111a93f3812709f581403"
    sha256 cellar: :any_skip_relocation, catalina:      "e2478748ed0561c76af8f68b4067f42cd365ad7735a9d44dda159e9bd35a1c1d"
    sha256 cellar: :any_skip_relocation, mojave:        "3d9fcb9c4f2e70010681b88f0ceca5795773b849e7bc6f59689e90ad969a673c"
    sha256 cellar: :any_skip_relocation, high_sierra:   "06f87da95e1d1b0f53fbcd9c9ff36e4c8a0d3ea85825ac7bc648b3ab445e61ee"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/pastel.bash"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
