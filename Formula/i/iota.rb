class Iota < Formula
  desc "Bringing the real world to Web3 with a scalable, decentralized and programmable DLT infrastructure"
  homepage "https://www.iota.org"
  url "https://github.com/iotaledger/iota/archive/refs/tags/v0.8.1-rc.tar.gz"
  sha256 "57990aa4982e1421cfd0c50106f2037bc1a9116d545f579188892e13371eccf3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)-rc$/i)
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = ""
    system "cargo", "install", *std_cargo_args(path: "crates/iota")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iota --version")

    (testpath/"test.keystore").write <<~EOS
      [
        "iotaprivkey1qrg9875hq63wqnya0hy3khlkfjvarp009chky42uu2gu9c2dsv32qk8r7ae"
      ]
    EOS
    keystore_output = shell_output("#{bin}/iota keytool --keystore-path test.keystore list")
    assert_match "0x7f21a048ec0e1d82d2e4a89a3b304e12813cafce1e8410f7a8d3be33c214c422", keystore_output
  end
end
