class HeliumWallet < Formula
  desc "Rust implementation of a helium wallet CLI"
  homepage "https://github.com/helium/helium-wallet-rs"
  url "https://github.com/helium/helium-wallet-rs.git", { using: :git, tag: "v1.6.6", revision: "4becd5fd9f817ecfee00dba3177a64c7fc223bd1" }
  license "Apache-2.0"
  head "https://github.com/helium/helium-wallet-rs.git", { using: :git, branch: "master" }

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    prefix.install "README.md"
    prefix.install "LICENSE"
  end

  test do
    # Currently disabled since `helium-wallet create basic` requires user input.
    # system "${bin}/helium-wallet create basic -o wallet-test.key"
    # assert_predicate "wallet-test.key", :exist?
    system "#{bin}/helium-wallet", "--version"
  end
end
