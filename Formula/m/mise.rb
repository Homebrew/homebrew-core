class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.6.4.tar.gz"
  sha256 "da148471e1e86a907d255c06c487f78ccedd84fa737f8288e4a7205dd2e114aa"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ea1014b9cc5d22ff0b5c017f6e015b850b8744a5baef8029a556bdd8a65acc49"
    sha256 cellar: :any,                 arm64_ventura:  "f2cd22e361cdb83b901be3c407bc3d0a58bd486d618fabd0e1fd4f2749f229b9"
    sha256 cellar: :any,                 arm64_monterey: "ffe0de12ce86c8d969d359e46d450c72af35a5952a5f581f6991ef5453920ba3"
    sha256 cellar: :any,                 sonoma:         "3581b399651d4423641abf270c882932b74afe4a386f8dfb88a9f7b386e9e903"
    sha256 cellar: :any,                 ventura:        "acddb0e7ce26683114802e4994a80006c36babc08861ab43a6182aca6236c6a3"
    sha256 cellar: :any,                 monterey:       "1319610bdcc0b9147db9f0ba95b77624d330a6d92ae5102f3e8e49caa24d9df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441469b526d861585fcf8125d2907b680cf10b9fd436d26954bf88060c94add8"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system "#{bin}/mise", "install", "terraform@1.5.7"
    assert_match "1.5.7", shell_output("#{bin}/mise exec terraform@1.5.7 -- terraform -v")

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
