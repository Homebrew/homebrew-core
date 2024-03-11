class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "bbe24060197be5954817d035643b8abd1c05a6ee2e67fd8868b211674f04897e"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df9aad58efc47a33b1a3d7f744afe001e9e2a6780955e56f8df316935f64abb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8df8b51c6a321d1e519e9bc08189f6aea9da3f4612d812741063f1e0948a560a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc00aee0a24d434c895b90af83b0683dd3671a8ca9f784405ab8f581e9a90804"
    sha256 cellar: :any_skip_relocation, sonoma:         "4140bc7c48e702e78c63356b0436e07288647a5b05e1c72cb4fb4c2abff06025"
    sha256 cellar: :any_skip_relocation, ventura:        "a953e14c1e3470171a1d417c594b341a351430ce91721aa76d8820e038448097"
    sha256 cellar: :any_skip_relocation, monterey:       "1d8aa3b6952ead005a7d3241986ca652db0ff930b51fca26a1dc9f5eaba47c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98cc949c0bbc8d8ddd8b635db81553c644c65afa78c1f15c4f41d617261af062"
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
