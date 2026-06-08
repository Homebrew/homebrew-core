class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "d709a3538d098d90af754d26d7d797315b5b8b4fb820d4201686f993bc580830"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1db1ac89dc5949f41ce569664c3de1e62dbbacf6cf1d37efb99fc6cdd8aed1c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c883063a51e6bcddb6622de8bf4aae3d5ca0d166fbd8c5af30519d5b5d6bdaca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fd413497d09668b73a83c58e3738855584016070ecf7d7c14a79c6d101e219e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c1b6199c48567dc758448f9511c5008a52a97b85631e465fde0e96b513f9030"
    sha256 cellar: :any,                 arm64_linux:   "115759fa1a743561d35de59fb79c547c05e17a7d187d0a5cce326df6b99f58d6"
    sha256 cellar: :any,                 x86_64_linux:  "8f492c78e9aab51535dfc3d9669f65e559ecd256ebc40899dfec8329e57ff5de"
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
