class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.5.16.tar.gz"
  sha256 "88f426c2db4d92cfa42f1179fac8d227c0137e174989cec1f58eec7ff8881d22"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db4f626f5a1d6dabe526ac436f29337484e70755420de8effaaae59a21074d3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38e689bd6ddbb02073bcca4b8838f0e7ca9f27e8a7119ea12df7c52ca15ec0b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcde07e9e5609acb8f7bb80a9aacd3c45bd7e555d023d957b4f7bc651480ee86"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa284efb9aee5c13a683151eb0014800e8330b04aded50def0f6bbab1607e9b9"
    sha256 cellar: :any_skip_relocation, ventura:       "4c8fba5c56497a521a8bc137a425429cb15042a166e120862b78c051153ba252"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb1d2a40460d3daba0226fd5f08da830350d6a0edddbc821976526208eed52e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "786196e3522f508bdbb0e6170722db1aa2d538799fbe16f771af1e2724e99ba3"
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
