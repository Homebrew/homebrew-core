class Dtach < Formula
  desc "Emulates the detach feature of screen"
  homepage "https://dtach.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dtach/dtach/0.9/dtach-0.9.tar.gz"
  sha256 "32e9fd6923c553c443fab4ec9c1f95d83fa47b771e6e1dafb018c567291492f3"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a3296ea100c480737f279e984c3e0cf25d0d5844aac527c09cf9cc1ff3bb4ada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "df21c7a193afc665bc0d8e35b51990fa1c86a7d586acefc9248641e2fc93ac07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "936dc52943de4d68d3acba73b5537df04e30ee6ed0e75148d7ed4270469c8675"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f1ef3983dedfabc3580bf8348e913f58a25f858f3a5937664dd70014f0fa1a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e25159bbd5055fc22962d923496e78c3e49ff919243593e16960734002c38dcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e90da47e413ace287b5144813af99ee9f2bb8cac8c435189557db29aa597c681"
    sha256 cellar: :any_skip_relocation, sonoma:         "c780cda9b47c04079b652c9de889c797125979197880a5551b5ac0127a165b16"
    sha256 cellar: :any_skip_relocation, ventura:        "8197e8606d40305873646270d38aae3973190340c46d0e47c66a38cc91bc1824"
    sha256 cellar: :any_skip_relocation, monterey:       "2a7c1c3b1d3ed2f0461ff94f0ec8574b4b2baf68e83048cf1f7b26c31ca76826"
    sha256 cellar: :any_skip_relocation, big_sur:        "2037a41545a48ffd293c55deb33a675a6d304df1f25c46e6f9b85969e0968d78"
    sha256 cellar: :any_skip_relocation, catalina:       "67d1aed450f459a8883148d7ce9bf89cd98025232ae6ec061381297e54276e8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "20f84e730ed5ca882c83d0fbc52a6a75d4c42a5b31c35505d17b58a8d8b2675c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e64d6a2ccdcb1bf8c9de85f9542d228b2f12ca97807045c24d42d3fb2cf047"
  end

  def install
    # Includes <config.h> instead of "config.h", so "." needs to be in the include path.
    ENV.append "CFLAGS", "-I."

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make"
    bin.install "dtach"
    man1.install Utils::Gzip.compress("dtach.1")
  end

  test do
    system bin/"dtach", "--help"
  end
end
