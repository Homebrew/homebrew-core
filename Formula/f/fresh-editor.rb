class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "50cd2cc1750ae4726326a524803b101ce9f6c4b2df222cd8056b3e91411fc602"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccfe98b1418530a41db3c4065f26c7fb0be1389737b98176581d9e6a84bf87d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2584bc3341bf005c90c5ca0bb47166e37a211562b65ea15c032a2c77342635b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83f255290d6cfc3facebae670f391583403620cb144a8d3805a13bb9f0d76613"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd739840ad0c0fdc575e3a8be50fd85f825771ccba7b513b271f4f4a4775dd1f"
    sha256 cellar: :any,                 arm64_linux:   "bd4620147720c557a7fe2c6479332258e5f8a3542240dc50863007cc977b25de"
    sha256 cellar: :any,                 x86_64_linux:  "8ce8a3647c5d01550332c6d9e8a6927ff555231930f1ac3b3db0a930e4eb3652"
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
