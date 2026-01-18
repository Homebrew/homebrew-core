class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.9.6.tar.gz"
  sha256 "2269da448584dc43afad927bef5d4873edca3fdb6c00037af73e908e7efc5019"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67600f0cbea8ee1cd1a68e71e039200a7821307351af4dcb1588a6a6f8eedffe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67600f0cbea8ee1cd1a68e71e039200a7821307351af4dcb1588a6a6f8eedffe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67600f0cbea8ee1cd1a68e71e039200a7821307351af4dcb1588a6a6f8eedffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "09777fe5ed746b5cc2a28f821738b51a0d804ce98b3c739e2c1810bf2cdff836"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4192ab03444a21238a8db4f5b335d42208f6db255ab808d1d3b468b558191ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c617347d0bcea1217c9110a6fdcf1d2a55a91cd1d6c223ce33fa1d1ade9d258"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
