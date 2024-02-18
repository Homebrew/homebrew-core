class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "23d958e4c07075d62b66185fd07bb862457f56c4e518e62650fe5650c738a8f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80cbaf50c6c9f08b073e27445c4d3dfad73a020255a26f1f207efdc0ae0638e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1776e745ea7afbd4b2fc5f34aec4063c44b01d6581f373aa026b4ef7ea55523"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "359fafc884243814d31f62073c6ea4333271cff375a255eb7456a3cf0376cc78"
    sha256 cellar: :any_skip_relocation, sonoma:         "85f24243e5d9f163be61d2daf51390e7ecde2159bcc8594182f105082b6bea81"
    sha256 cellar: :any_skip_relocation, ventura:        "d8132a1f9dbd6db7e788777db771fe3bb940af20316188d68d7122229585fd19"
    sha256 cellar: :any_skip_relocation, monterey:       "fe57a47d8371de9896bf50347d98a3c337e016c298bcce7cd75ea47096c541c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "031122bb316749a63cdb3e6ad53262531d6b8a5bab50fe44dcba0df0e02f060f"
  end

  # Use `llvm@15` to work around build failure with Clang 16 described in
  # https://github.com/rust-lang/rust-bindgen/issues/2312.
  # TODO: Switch back to `uses_from_macos "llvm" => :build` when `bindgen` is
  # updated to 0.62.0 or newer. There is a check in the `install` method.
  depends_on "llvm@15" => :build # for libclang
  depends_on "rust" => :build

  uses_from_macos "ncurses"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@15"].opt_lib

    bindgen_version = Version.new(
      (buildpath/"Cargo.lock").read
                              .match(/name = "bindgen"\nversion = "(.*)"/)[1],
    )
    if bindgen_version >= "0.62.0"
      odie "`bindgen` crate is updated to 0.62.0 or newer! Please remove " \
           'this check and try switching to `uses_from_macos "llvm" => :build`.'
    end

    ENV["CLANG_PATH"] = Formula["llvm@15"].opt_bin/"clang"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
