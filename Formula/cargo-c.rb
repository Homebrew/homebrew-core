class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.10.tar.gz"
  sha256 "e4ad4f6459522b4b1f485c2637f328f267b81bc46fdd85ec9ddbf011aa7873eb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "66aeb043716db062fa8e706153b92b23ba0e364c3f38da6a8cc13ef217031f65"
    sha256 cellar: :any,                 arm64_big_sur:  "97872ff704fc91d5a1d27133bb41bf253b38edad9d39089ff56421933cd3cea9"
    sha256 cellar: :any,                 monterey:       "739bb8b5ef685fed9734e96579f9389028765e772da26f267a95e037a23d1c06"
    sha256 cellar: :any,                 big_sur:        "484b8e813a0af81d26b660a90393de3503b3c5fe016ae93389b6759271d947cd"
    sha256 cellar: :any,                 catalina:       "44658a0bbb06e7497c993dadc986ecd2907b041310e217577f920a944c39b208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88078fe5d3739f20760329ff00244d75455426fa4b125bcc1abdf7c5f53d0126"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
