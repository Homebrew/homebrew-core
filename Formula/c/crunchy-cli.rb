class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.6.6.tar.gz"
  sha256 "eed98cf770713653caed77337faf6d4da63e2ed42e545c2b124a62f8bcc0757a"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09989897e059dad6e5d12ed7d1e8bbcf738286ad6f9d6fd8249d66caab848547"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b84b75c947217edbf3ea60d6a3087acc9f58cbca13114a055d7fc16ea12bafa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "486165f3a184a9b3b87bf64c7df24e26f84c96880cfc0b80656b9a54f7b49eb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ece72dbc3e3a3148bba6f5f30ec36ef18b560f27e547de97f874672ccc7d179"
    sha256 cellar: :any_skip_relocation, ventura:        "b02fb962cfe38e5a5ba4dc0171f93ff116e6578a76f53201ec48a083cf338699"
    sha256 cellar: :any_skip_relocation, monterey:       "8bb82ddfaf0414017f69f73546a5890d63bec87f86d2f8d556b16eae1612705c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c60cb45343ba73c374bea34a80347db2cf5bc503874406e774bf479a62effae3"
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
