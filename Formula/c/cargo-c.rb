class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.25.tar.gz"
  sha256 "8054b12ae8b64259e7b63e40368406dd6b6510d5d92b658152b361c5d816a5de"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d000961a39255e57a9a166f798d9d3a0ba397951542bd5a3a52b92552ceb8c92"
    sha256 cellar: :any, arm64_tahoe:       "e1b43d0a3545e016870eaaf8f56ea91a97bacde9ae62c75760ecf89072d6834d"
    sha256 cellar: :any, arm64_sequoia:     "d1eb740ec4422ff990e5ffb335d0f365f63819022024dd6a9c1d0bdbbadff0a5"
    sha256 cellar: :any, arm64_sonoma:      "8e205671222539aef102d6b9bffbf01d87e274dc712a66160d5bad80297db49b"
    sha256 cellar: :any, sonoma:            "55670bbbf5d710dfe39f5f37b108e01e2ea37837c71e51bbf580dd0d55ad97ba"
    sha256 cellar: :any, arm64_linux:       "1bbab043357ea3f6258533f36e438c5dce8816fa7b2e7cb64ad334a956757a31"
    sha256 cellar: :any, x86_64_linux:      "f3b1795463b298662aa084f2e09d0f50c5c41051d0f3b64be9d8f6cc3f13bada"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https://github.com/Homebrew/homebrew-core/pull/197727
  uses_from_macos "curl", since: :sonoma

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)

    [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      formula_opt_lib("libssh2")/shared_library("libssh2"),
      formula_opt_lib("openssl@3")/shared_library("libssl"),
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
