class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/6.0.0.tar.gz"
  sha256 "3f21c9e2a4e86e1a5913e211d890b07e9388871e3d6ed526668487f56b11b925"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6ff688c8c96b42c393364da8caae2d668cc2df91fc977b0942738879dcd22fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "113dff27a8b7406e04186c6bab2a595440d56192ea630484c1457035b99c54d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d15826acd1436b9a901cc8f83dbb276585ad9f874a532555b352a7e10f98c754"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b1c1fad81b4685ebde16a505243a6f7a54d83190df0a1eb42144ef0f0132382"
    sha256 cellar: :any_skip_relocation, ventura:       "5f7db2cdbb039c2878f3fc5adf5cb7723969c3498fafee5e530a5602d7e1fbbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2341e4404521835fa333f5bcdc2f1c8b551497eca97690517f3f4298d0474c0d"
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
