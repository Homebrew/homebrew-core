class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "31b2b32311a8b45939f5510b51c0dcb29c181691903ad6a0284ab5afaeab2936"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1485c62587134200427268e2a274b46a5ebb5f639729834434cfd70f51c75c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd1f1d6cf7550e3fbb98ec11a47be82d42ea88a638499b842de6c2ec17eb5966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43d075305d45d7d4e3681442b874b21f6681c861afbaec0411f6a732db310e5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "86743a31409fe5fc90f2f0518a8895180b9d9d4a7c06b18e28c1bd35d235c9c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ec5e3b1e01608e187e3ceb3e73bc4e86906033d75093e132cb6a2f96d173c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e5b18cefa6c944dbf3831a76c4960d07c320469a64cc1e2c25d594a346571ae"
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
