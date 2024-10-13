class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/5.0.1.tar.gz"
  sha256 "2b5a42fc95b74c876257a35d13b603e06f1f2c58e0ca44a2c0bb23d023227c29"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f68c999d12879fe9960980ff26b5279ca0a6ff220a2744693e6021bef4624891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20f6bd5e3dd48632b4dfbd0aef95166b8504b21a0559a8356325abf2f416212c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84df0713ef2cf35ff01b418e6b7a96ff964d50b93ef8f38c9e0ddcbcc7873687"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35bf3554910bbe8d63f5dee7273614070cb1e88f7fe4a1c607d59b9e8f7f67a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "aeb37dec9f5e50a21152e4be7ea9cb64d82aadc04e6b3f87b6834235fab35151"
    sha256 cellar: :any_skip_relocation, ventura:        "e57ada90e68d0b54522c650a022754484860b5c6a6fbcc69f6265015eba6f596"
    sha256 cellar: :any_skip_relocation, monterey:       "62e3b2a5c78467e09b91626191785952c17e484f5cb9a97d87682951d320ad69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da088a0c38d10658b71d7baddf5cdb9efad45068455fc7db526a7f90d6a2fe44"
  end

  depends_on "pkg-config" => :build
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
