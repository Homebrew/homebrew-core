class Id3tool < Formula
  desc "ID3 editing tool"
  homepage "http://nekohako.xware.cx/id3tool/"
  url "http://nekohako.xware.cx/id3tool/id3tool-1.2a.tar.gz"
  sha256 "7908d66c5aabe2a53ae8019e8234f4231485d80be4b2fe72c9d04013cff1caec"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?id3tool[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c0c5fde02924517f49e33c33f18430726f0b613bb013fa73d0eb035a6d34755f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e67faa6f3ae68053ff10e5e16e3dfad49dd3f67a578114109a143c6131c44391"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd6e6e24689e48d6ec5c67fef4ab113b40d92b91a02d85a8d67744ad454e820e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaab957f04597caeef0f4d080d4e936743d154c3c0c2e62e228678f5d5123b58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eec5850fee5d290bad13de2cb4456b2e600560632be7b86309ac5c3f3f03697f"
    sha256 cellar: :any_skip_relocation, sonoma:         "75ad7009eb4917c7333de727e417b4057aca5256a85946f1b76dc72eb9e849ef"
    sha256 cellar: :any_skip_relocation, ventura:        "cef8ba04668ad9e85b60642b34da3c81c2cb9bcd6a509ed28cf50a99bd822699"
    sha256 cellar: :any_skip_relocation, monterey:       "3703e5cde176d1f1855da2b8091570378d77f64d7870222d5d6cf149d702cb74"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a6a25738f1961b7ebb929fe0e4746a60ef71fd28af06ea305c5f5d95ef10e60"
    sha256 cellar: :any_skip_relocation, catalina:       "ec3431bcd97a7852c292f72d45de19ad742a2e18bc8d6830ce5fc6e2351a8d29"
    sha256 cellar: :any_skip_relocation, mojave:         "053ce5a2222cac2bdecff1e97e73110af9cfbb199b77441ec5db19b4fc7ef1ae"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c98d949a63b2d26f6cff9d63d24ecdfbd48196f58111a9a244ec7319d2ea7c21"
    sha256 cellar: :any_skip_relocation, sierra:         "2b7bcf184092881638221c606ae50879d02478bf9d433dc946f63dbe2e68368a"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b5b4d49b4710a67df5200149873dd8c17131ef4a4eaac722a2095b1445d053ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "15050e11c91c720f0382457f0daabad0e6edc395cfdcbbc50bad30ecfe551661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbe4dde2f28fb22ebd981fa3faa4db03f327a43531c102a6a47a463e0f329d6b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    test_mp3 = testpath/"test.mp3"
    # needs to write the file to set the tags
    cp test_fixtures("test.mp3"), test_mp3

    system bin/"id3tool", "-t", "Homebrew", test_mp3
    assert_match(/Song Title:\s+Homebrew/,
                 shell_output("#{bin}/id3tool #{test_mp3}").chomp)
  end
end
