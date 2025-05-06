class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.5.1.tar.gz"
  sha256 "b6584c19918e1fc821f7cce10f0d58ccfe55fe4f525050ac5f249565e7b25bad"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4128d4efd5bda5d17402d6f16b5568848ff01bf684510c56e67d4be705937dba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406ed8f937d33d29d44ebed1dff977fd1f2ffb4a53079f3a40193ba9c9b31396"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "192ad5b05cd5a931bf73084fc515d028258eff87ed82459016974669a26f9438"
    sha256 cellar: :any_skip_relocation, sonoma:        "45c91db63bddf28e88dc4c076048b47e22958d1e531949a5ca9274232bf47b2e"
    sha256 cellar: :any_skip_relocation, ventura:       "6604e6039a4867c9906017611f978b8154095d28159e32e3e165013b2d7c9672"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9be9b52642757eb2031844c57daafd2bc759d35d28ec3359b1fe322ded8eefb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f561d9d7a44e90d4989b0fa7bfcdfdf5d655bb02f2683136e5b6e1bd0579fd85"
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
