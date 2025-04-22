class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/6.1.1.tar.gz"
  sha256 "26ef1ed685f4b94190914a0e03127f7b7f6a488abf65758c19092dc6b9034b2c"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0580eea478d4c02659b1a8637e4ee7c2921bf4f7922546315f9f06b11aef64e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e267e70f355ad821be193f973081f0e0abc69b2bdb08fcc6a32aa977c807754c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80f9f55257157bcdbce39f036b9ce0c82e82a6d58b46d4fc773dcec8e296d333"
    sha256 cellar: :any_skip_relocation, sonoma:        "8791f49c5281f560ca43e6539cf8e20ece6284285458a151f8762c262799a841"
    sha256 cellar: :any_skip_relocation, ventura:       "c2687dc9b8c865a50eaa19de4022a19492ede31d4a24b354f347a4f90c8f4c17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84c1996b20423a345f84c535e53c01b297a499d838fc6df4aa0c08ed184775a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eba4cba1f46c24cff1ffe75a3c342456564a1707b80b4a83e1eb02c62f736208"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    # FIXME: This formula uses the `openssl-sys` crate on Linux but does not link with our OpenSSL.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "packages/hurl")
    system "cargo", "install", *std_cargo_args(path: "packages/hurlfmt")

    man1.install "docs/manual/hurl.1"
    man1.install "docs/manual/hurlfmt.1"

    bash_completion.install "completions/hurl.bash" => "hurl"
    zsh_completion.install "completions/_hurl"
    fish_completion.install "completions/hurl.fish"
    bash_completion.install "completions/hurlfmt.bash" => "hurlfmt"
    zsh_completion.install "completions/_hurlfmt"
    fish_completion.install "completions/hurlfmt.fish"
  end

  test do
    # Perform a GET request to https://hurl.dev.
    # This requires a network connection, but so does Homebrew in general.
    test_file = testpath/"test.hurl"
    test_file.write "GET https://hurl.dev"

    system bin/"hurl", "--color", test_file
    system bin/"hurlfmt", "--color", test_file
  end
end
