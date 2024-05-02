class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "91b065f941ee2bbc81b45c1e5a91b764fbf9a6549f48fb59c57a0112ea05ec75"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "128a938140bba221a3af676c967f29bc2101f141acc379c5764439e8469d1b15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9e5a0cd87062172dc8a1a6241c4d513b647b82a43a90073874c54c45c0aabd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a2666c9cc880d97b6c91aebaddef195f0318255dbbf3cbb4ed327584be7be2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb71a1c9f7bbac2b537baca22b7b8aadf76df4f70b5ca831e48001c760a4400b"
    sha256 cellar: :any_skip_relocation, ventura:        "edd0bae9270de707ab440e71f6bc332e4e763256119c03775423850cdfe7715d"
    sha256 cellar: :any_skip_relocation, monterey:       "03ef08643932a3136e3ffc3e5a989463a51abcfe4350808ca7e7214f5e98d986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d11cb3eb6c2a994ef5fe0508d3b821311a1d0594af50c640962ca0bc0038abcc"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--no-default-features", "--features", "openssl-tls", *std_cargo_args
    man1.install Dir["target/release/manpages/*"]
    bash_completion.install "target/release/completions/crunchy-cli.bash"
    fish_completion.install "target/release/completions/crunchy-cli.fish"
    zsh_completion.install "target/release/completions/_crunchy-cli"
  end

  test do
    agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/119.0"
    opts = "--anonymous --user-agent '#{agent}'"
    output = shell_output("#{bin}/crunchy-cli #{opts} login 2>&1", 1).strip
    assert_match(/(An error occurred: Anonymous login cannot be saved|Triggered Cloudflare bot protection)/, output)
  end
end
