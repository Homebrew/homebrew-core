class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.4.2.tar.gz"
  sha256 "bbe3fe4a6cfcc92717fa75d7596c1d4f65e0daff2cd79965ac8d7f57704a3842"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dfd45d4a64933b87e60ae9e04327e4e9ec8c7973f56375e23da37866f42a63b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "083a3e736bb73fab7d4a46a51a6e851e48863f9217f7bad2600248ed0e361290"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3c8b3d8684373adf7933c085951d0fb67e378674e339708af1e20037a8bea34"
    sha256 cellar: :any_skip_relocation, sonoma:        "55fa9b5d0d0483a2f975145a7550ab3c4be737d0c0edbdc4ccd67eb5b2ec0401"
    sha256 cellar: :any_skip_relocation, ventura:       "db6f584fd6423406d03e1745520c82cce24c4f58b79f7e7a2004570409b542b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6313c940ee9c2830250074f7f9ebf975602b1a48a72a479907e2aa8b2a01972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "360704f04a8cdc75dfa37383b3609fd8cb019afbce8ea4f3b4fe8373cf563205"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
