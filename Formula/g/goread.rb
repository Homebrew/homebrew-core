class Goread < Formula
  desc "RSS/Atom feeds in the terminal"
  homepage "https://github.com/TypicalAM/goread"
  url "https://github.com/TypicalAM/goread/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "a7a6315e31d11edb9b4e50aacf96648c6e9b69e87d2f7ed9132d1a9b13eace7f"
  license "GPL-3.0-or-later"
  head "https://github.com/TypicalAM/goread.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8beff34809f0f36d138e70a4f27f1de377c4c5f50a316113063763ccdc2e78a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4f853cc93968f52207509e674a15e834993c7c759d05a87edb486495a55a624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e52c07ea3d8d8298053de330c2eb4be46b3c2cc4b9d0fe9879d4a9435daf29d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "555d7133b4444a8e229d90a34d6b686e44d2f7cb4ef1a6ba47655619ffaa98eb"
    sha256 cellar: :any_skip_relocation, ventura:        "0864fafc97151aa134138f2061cbba3b0fb8d368e4df7620c4c4f3e67cd3b5a4"
    sha256 cellar: :any_skip_relocation, monterey:       "0a109de75b4cb2145df82741da39e91aa6edda595847feadc6023fe3c3103e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b1958e6f5439960640edc214bc74144d0454649631b75ed9966df61b73aadc0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/goread --test_colors")
    assert_match "A table of all the colors", output

    assert_match version.to_s, shell_output("#{bin}/goread --version")
  end
end
