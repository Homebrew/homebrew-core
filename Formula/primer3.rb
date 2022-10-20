class Primer3 < Formula
  desc "Program for designing PCR primers"
  homepage "https://primer3.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/primer3/primer3/2.4.0/primer3-2.4.0.tar.gz"
  sha256 "6d537640c86e2b4656ae77f75b6ad4478fd0ca43985a56cce531fb9fc0431c47"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/primer3[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3651f78cf06ef84f0eaf2d4e9b136cdbf8775439021eab152b7c436e88f2ef65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fff8629911a86916818473abdca4480363217ee8c371808bf22d87449c02df6c"
    sha256 cellar: :any_skip_relocation, monterey:       "c188cd7edb1bdaa613ec3307dc3292ccb9aa6deaafe1da6afa1540203a135cc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad1892c4c516bd5865fbf63eb5ee843c6c090c2977d762bf029b907bed2c4730"
    sha256 cellar: :any_skip_relocation, catalina:       "34845e20a0946fd5bc34d281766abddf173a836b492048e20488af58647904d7"
    sha256 cellar: :any_skip_relocation, mojave:         "42d8c134f8dde43bc127a0f5f66eda246de195604b952ed9b8ac6b3fa8aba373"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f72fac01bb380b5ea55b41249b2d6bc2f799e9cb7cef55fae0a1f92e1de7ba64"
    sha256 cellar: :any_skip_relocation, sierra:         "0337aa96c5d5f25caa15177236c5f5d269adaaad01cb63a77c933eb01f7a6ed0"
    sha256 cellar: :any_skip_relocation, el_capitan:     "45ca3618888becc12b4d6be0ab9957ba5c8fdf2e818f74dc5312900c641b06c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e1869f3223dcec1add22b56adf91c9c6e2db4ff1920c73f8d056eeef5ef661b"
  end

  def install
    cd "src" do
      system "make"

      # Lack of make install target reported to upstream
      # https://github.com/primer3-org/primer3/issues/1
      bin.install %w[primer3_core ntdpal ntthal oligotm long_seq_tm_test]
      pkgshare.install "primer3_config"
    end
  end

  test do
    output = shell_output("#{bin}/long_seq_tm_test AAAAGGGCCCCCCCCTTTTTTTTTTT 3 20")
    assert_match "tm = 52.452902", output.lines.last
  end
end
