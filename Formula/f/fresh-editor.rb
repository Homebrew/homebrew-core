class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.17.tar.gz"
  sha256 "b26da263ec943ae24f42e1d9b4295416b56488e8eb9db8e8bbd5f46526a5868a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea1dae0bd824a80662c99828a34ee65d9630eaefa0ca75519459ec9d72a91bde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4036b837f4a8ac7e27e42b24693c27db4c4939d8ecb66d5a23e58d56cb391a1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11fb70c02c0c629bccf34af7771e0fcc3309e488b57a0ff9bafa193319904148"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae4f07e4d01bf0f794e2ec393910577163d9aef252eb87cc13435af5592a4e45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee4dc473e47458f0f34c29ce4026aa343539ca68e3ca24a9e3345011a5004750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b8cf88dcd7010d51b8450a10ae914e3cad90ea0d8b781079bbf04b3b982ab6f"
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
