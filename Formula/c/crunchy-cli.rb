class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "bbe24060197be5954817d035643b8abd1c05a6ee2e67fd8868b211674f04897e"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23d72a0c842442218cad36cfa9a44582cf0cf486fe165b0897d2fadf4b5ed5d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebc552e520e4ed7b60e7b45f2bb96e17b16a79787e8404151bd76a2c728f9505"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67481bead386218a2d459e53e518ccf7631eee7ce214bc72225a453c67274cd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4feeae1dc455e5ee37fe52bb66b93d5818ffc2a9726882ffee971ce09217823d"
    sha256 cellar: :any_skip_relocation, ventura:        "19953ac46c9a2af8cb6efd96a26172e17f63c7d6313fc3e278d423c03b0ba852"
    sha256 cellar: :any_skip_relocation, monterey:       "1d68c04dd9cb6a2e073a51a33bdcdb6c64a0e337054c3b580faefe5800b13127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "276d680a05c9881679e2c4da2ca7ad2956e2d22f0f589ebce54acc9115fe8ed9"
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
