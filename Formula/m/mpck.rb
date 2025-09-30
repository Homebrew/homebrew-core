class Mpck < Formula
  desc "Check MP3 files for errors"
  homepage "https://checkmate.gissen.nl/"
  url "https://checkmate.gissen.nl/checkmate-0.21.tar.gz"
  sha256 "a27b4843ec06b069a46363836efda3e56e1daaf193a73a4da875e77f0945dd7a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://checkmate.gissen.nl/download.php"
    regex(/href=.*?checkmate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d2724946fd57b26d6af09556f4542e2eb04721e2f3043a0e8a38eed5144e0550"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "81d2d6e7ea068e0cc9f43913ca1e946efe3cadd19a6e89ee88a7b734dc800cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eeb22c03ef069272b7a17479aa9c88b3778fd6ffbd4b9196da8b1b68bcee68a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "319209a5338628eebd83135c485ae2767ee55361437e420c8f3940d90de7ec6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bad165fd261de0bdfe9c3a5cb0d91204cfc42bfccc9562de1086f16f0bfd3b2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f963c58102f58169a5ea1d6264f3ea1093a62fd6461332d5e70d0e1ad9aa5d79"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1f6418aa6a0cbd47ef102d7c099fb9eebecafd8e5609594162d79a25efe9d5e"
    sha256 cellar: :any_skip_relocation, ventura:        "531607b5301ef2e894c27cfd04f13eb435ad6eebb26213de07671809b20ddba3"
    sha256 cellar: :any_skip_relocation, monterey:       "5eb5da1b3e78b8aba77f69dc5df1c596238a401da8b3bbd2c34f971d9b0d2874"
    sha256 cellar: :any_skip_relocation, big_sur:        "215f2f66b6567409359c6a0f784702df9fcc2e0c86edcab52fc40f91b6911bb9"
    sha256 cellar: :any_skip_relocation, catalina:       "45f8695f2758dd07237c333e8a17aa38f8d0aed4e87e8b5dc7fea7bf4537b0e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "22ac6376ab61a0f98ba1cec33f9fbe3af88ada272ebdcf90bc1ff2c345174496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fcc623716e6209ba20e0e6211f90f96e2052b180282694d608677df4bdc72ed"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"mpck", test_fixtures("test.mp3")
  end
end
