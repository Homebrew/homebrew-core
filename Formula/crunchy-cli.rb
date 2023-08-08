class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "7a693668bff8aca9029106bb143692cf74eb2376b568aea8173e4b6af45c0b45"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--features", "openssl", *std_cargo_args
    man1.install Dir["target/release/manpages/*"]
    bash_completion.install "target/release/completions/crunchy-cli.bash"
    fish_completion.install "target/release/completions/crunchy-cli.fish"
    zsh_completion.install "target/release/completions/_crunchy-cli"
  end

  test do
    output = shell_output("#{bin}/crunchy-cli login --etp-rt invalid-token 2>&1", 1)
    assert_match(/(invalid_grant|expected value at)/, output)
  end
end
