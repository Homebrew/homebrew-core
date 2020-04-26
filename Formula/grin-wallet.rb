class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v3.1.1.tar.gz"
  sha256 "0151e7235ca52381ffa30ebe06cdb6841afd48331f68fb477bf7d5b740e03cc1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d15b6d81f22d8785ae23e1a784c9c9d8e7bb7f7707304cc93ab864642d9bcd19" => :catalina
    sha256 "6272bb8a6a2468743aa4092e5a8c08af926e136dc747c2d0136e235fdf7f70fc" => :mojave
    sha256 "bf9d41682a4f6a0a0ccd5c8affede0d4233d2050627fefd06aeff83c0d213156" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    # clang-sys breaks things if it finds the LLVM formula
    ENV["LIBCLANG_PATH"] = if MacOS::CLT.installed?
      "/Library/Developer/CommandLineTools/usr/lib"
    else
      MacOS::Xcode.toolchain_path/"usr/lib"
    end

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_predicate testpath/".grin/main/wallet_data/wallet.seed", :exist?
  end
end
