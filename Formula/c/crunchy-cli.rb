class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "3219493204e7e34fa14240007ea905ec397db75624ea6c0570a2fdfb6a6366ad"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d2664371de1eb0220a79ee2a927cd776a7b615051b19507cb0df31703a15794"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87fcbe6bd5c275ba1d6d3b666a412947089ce8b62b13a737a8d9bdc95c5a9ea9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43b5b006b103b6c95908554031dd6d637155175b60484af9b687eab0c6536219"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5d078a2d9bf465a08e31a5693bbb108e4575349955754b1bc28cf2e8774a039"
    sha256 cellar: :any_skip_relocation, ventura:        "8c68686bbb9309ec503ab1c91bc9e8c471130747887cd1bce1659828a05838ce"
    sha256 cellar: :any_skip_relocation, monterey:       "597444a784f1ae70fa3eff2b38217d66b7bce755eaf2480301b0e9e3f39183cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e74a4e7466b90948ac5e8bdf4800025a14fd2785eb0f2b3529dea1b1ed963c5"
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
