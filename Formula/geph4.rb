class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.7.10.tar.gz"
  sha256 "9be746e50a3525867cf4917490d86d68f6b118fcafcac7ec134a094b50923488"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "086997ce2dda9306e40a331550aa10e67a5e926862ce0c740285c72a36531713"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "463ba71783b211bcb0df4b340b3ebaa55d5ac1c699ea517df58e68549fb54a6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f320fb34b73d196a49ad29dcceceb348df2702815c42ff27bc6af51418956d7f"
    sha256 cellar: :any_skip_relocation, ventura:        "f388d802bd17ec979e27c97cd5913194f82e397ebe2c21f507c59bebcfc95bc9"
    sha256 cellar: :any_skip_relocation, monterey:       "45843fb15eccea8fb614316a54fd6c9da1b5f6141fd68de155f43c9245a77083"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbc3139023e64750f1549b1165c0e87bd3dfb4c18186fc7d1d397db9518bed56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c929bd20fbdade3706c664bbeb81a73ddba90c32d31a80c2a845003b7b0cc1e"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
