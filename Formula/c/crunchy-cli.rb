class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "c045fac99b1777f4b15ba82a197946fb0d12a94c8acda53e37e092333f05f4b0"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  depends_on "rust" => :build
  depends_on "ffmpeg"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
    man1.install Dir["target/release/manpages/*"]
    bash_completion.install "target/release/completions/crunchy-cli.bash"
    fish_completion.install "target/release/completions/crunchy-cli.fish"
    zsh_completion.install "target/release/completions/_crunchy-cli"
  end

  test do
    output = shell_output("#{bin}/crunchy-cli login --etp-rt invalid-token 2>&1", 1)
    assert_match(/(invalid_grant|expected value at)/, output)

    assert_match version.to_s, shell_output("#{bin}/crunchy-cli --version")
  end
end
