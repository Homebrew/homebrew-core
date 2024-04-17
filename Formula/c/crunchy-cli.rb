class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "e192d31fecf265ad9ae6f11310d205a448cb27a05476cda04ea8163262b511a3"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30d1cb1ff09c259d8937e0edc85b68074f972cd4bdf83f24a8ed12a0d9eea3ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffc25099dbf5381c4d96f29742c65b162ba7edc6c08d2ff8e0eee793b7c386f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24b53e890705cf55eb531ed4b2cb851d378b094f553548a624fd1751b4625b0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "798d9890ce3e1a5cad23c268093214ec234ec92a57f4e431f864c604097fdbc5"
    sha256 cellar: :any_skip_relocation, ventura:        "fa8053bae811009ded36cab05e921067dd74b6447ba6647e914255e218dc2e6a"
    sha256 cellar: :any_skip_relocation, monterey:       "94b92758991b7e86e86bee53ff8db36add19f11daa4082e913effcd5f7f8f8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3851841bb0cfb2462fbb1401b4bda9ebae43a0ae2d8e811e35e0bd2bd5777d10"
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
