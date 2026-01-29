class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.95.tar.gz"
  sha256 "488fd9f7fbaf22e3cb9b65124183bc5cdd013116a3e6719e79b9fc6678d9a816"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a658e07b35d75e494b9e2f97aa086122682973df012af2434e74abd54cdd1627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33c25d5f34251066b6c380f30047800021728ced10d4666ca5341a801d342b50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b8813534c627d23f5202b51d6d56b717238554137f6bdf462cba27d7d818f01"
    sha256 cellar: :any_skip_relocation, sonoma:        "846decffc337518bfd2eb7c09899b1623575884381423a2482bba2645d228ead"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c31bd193a8b71da50623a828bc93a4f9465118553eea26e5497d926ea9f9def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d124f42a6044faa1941c8348916d6c3836cc885a7d2fe5b92c73d9608916c896"
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
