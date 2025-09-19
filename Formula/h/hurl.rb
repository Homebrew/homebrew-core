class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/7.0.0.tar.gz"
  sha256 "3f505848aabd9eec78360928b0fcbfea237a049b5c8d25b8d9e0aeb3f9d8dfed"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dd53506b57247d6b5ec551212433ec0adb199898179ad11a51a8162d42849db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02271320877e0025edd124cfac43983c66d7e434a00d01c71fa12fd48bf1d174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "569b483cb9265abea3607bcc534363052304c71ef72982377ac9112d658dadc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fc5113c8ed3bcb8952ba034a152daa71da8fd84ac7e46ac576f088bbee2a9c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "056bdf68cc286e87ea170f3802a46d7a0a09eb9c7ff7f0feba68ad747d3ad3fc"
    sha256 cellar: :any_skip_relocation, ventura:       "63cb4d7e897774ec1ef425771e88aaccbef5bf823aaaf184c765f6749d06513b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4164ea2b7cfca670493aad3b2dd761a2f44077fbba3b4339eeaa1191b98b119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd38d4a95494e8df47aac5fe57b8b3585358afedb990683fd26ac7c1de49728c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "llvm" # for libclang

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
