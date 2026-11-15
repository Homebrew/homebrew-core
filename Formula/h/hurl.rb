class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/8.1.0.tar.gz"
  sha256 "2e45678806a8a1c7307d4b4298b11aab6d947799bdce986c67fd9c693dac98a5"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33de9945cc0b134a88cb255b77b6912068a0af3ef5b618def9533e9e73567b0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "839c2d5dba96a3c62fedc0d833eee35848f0aecff90d4015ab311e2a4f0d14d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f967402fae9998f3563969d038d55076105f079ae3b66caec8ec5499b6a7ddd"
    sha256 cellar: :any,                 arm64_linux:       "d3f3c7900b9bc51bfd7517cec28af35fe763455377b687cfe715774a671112d0"
    sha256 cellar: :any,                 x86_64_linux:      "4b1c37a028e22f0e727425e81abb59da366d430b1f1366b6e264ce29f1e0b507"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "llvm" # for libclang

  on_macos do
    depends_on "openssl@4" => :build # for `openssl-sys` build script, not linked
  end

  # `test do` block requests hurl.dev.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # `curl-sys` pulls in `openssl-sys` even though macOS uses the system libcurl
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.mac?

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
