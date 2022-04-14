class Libindy < Formula
  desc "Indy-sdk for macOS including libindy and indy-cli"
  homepage "https://github.com/hyperledger/indy-sdk"
  url "https://github.com/conanoc/indy-sdk/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "27fe05b8231fee5e36b63a76f516ad4bbe1a30a56dc7da701e749aa8479255aa"
  license "Apache-2.0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "openssl@1.1"
  depends_on "zeromq"

  def install
    chdir "libindy" do
      system "cargo", "build", "--release"
    end
    chdir "cli" do
      ENV["LIBRARY_PATH"] = "../libindy/target/release"
      system "cargo", "build", "--release"
    end
    lib.install "libindy/target/release/libindy.dylib"
    bin.install "cli/target/release/indy-cli"
  end

  test do
    system "indy-cli", "--help"
  end
end
