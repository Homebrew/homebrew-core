class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.95.tar.gz"
  sha256 "488fd9f7fbaf22e3cb9b65124183bc5cdd013116a3e6719e79b9fc6678d9a816"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "219b1b248aa9342f02808445f43ea085cb19ac2e3ef886628b28267446a8341a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f408876e23fd0aafc7f2806dce860dc83884447a8cb356e666448a55e81c29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2850b43d15807cac2083c7f2addf91d2b881715f9b380418bac08b9649cefa1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0888ec6dd503b19784e82caaa34eed43f47b7ac9ed3b9ff4a9c2d3366da1ee9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afa1a9e6904d68d467a46eaef798de0a3b152ee34aacda5a23fcd5c67bcd6422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83d0472c1d0e37028cd72cca99a390e828fd260e458c863b9de3e8952d0ae37e"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
