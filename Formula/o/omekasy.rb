class Omekasy < Formula
  desc "Converts alphanumeric input to various Unicode styles"
  homepage "https://github.com/ikanago/omekasy"
  url "https://github.com/ikanago/omekasy/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "0def519ad64396aa12b341dee459049fb54a3cfae265ae739da5e65ca1d7e377"
  license "MIT"
  head "https://github.com/ikanago/omekasy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d090085c33c82273e051eec3b46fa61dd1fa4effbfbbeb80d29d51dbceaddc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19a5bd78d4a91060a4b52b88d2d2948e1200093fb327f10037be87684688788d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f77760ad1454cb1f58c6b6c8fe508549500b316f97885d55c975c7bf4bc1db4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60215eebac2b7bf72f95b6b1deb0d73a50070bad4bc9b3d41a83a1eba7bb48f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffb3cb8ae428ce6dc0996da234ec6ae3ba34cd4a891e15f59486f18a3652b115"
    sha256 cellar: :any_skip_relocation, ventura:       "6a78a6792a171d0c382e9b0452d7bea97ee9a1c62daf9650d0ec05dd935eb43f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a297886d8b90eb498b4436c7ef4fde2c72c0f98d1d687a23fa44c0bef9890d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc9e6b08ffd9ad5ee37b0f26604c9574b616c7923e12bd5abe22dbcb28122f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omekasy --version")
    output = shell_output("#{bin}/omekasy -f monospace Hello")
    assert_match "𝙷𝚎𝚕𝚕𝚘", output
  end
end
