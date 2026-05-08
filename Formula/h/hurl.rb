class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/8.0.1.tar.gz"
  sha256 "d5ea72ed489b9de319d0306d7b23728c4d284ac505adeb06c297ff5da1cf0de8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f15ab5653bd4c92d74db286c58d54b16e91d2e758fde2cdd26ce1add3f73d508"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6132eb546f9cd5b0f2ca0b926bf5b136c7051dd8c853fdaa8c5a4873cd7973b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aa40c19792fa00e24de2db64d60f5b9a6d88d5712d611da0b58a7d2e3d1be1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeb88b9fee569adfcb1065bf13dcd5425d09cd8ad212bd1dd2ac4f3279648bc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2851008a9865376f05311536ac5ee96ecab6871e9e2da51dda6cfdbc0a72b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1e214559626b52cee946741f5de4b1b359e2542f29284fe2f24628a9969ccf0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "llvm" # for libclang

  def install
    # FIXME: This formula uses the `openssl-sys` crate on Linux but does not link with our OpenSSL.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
