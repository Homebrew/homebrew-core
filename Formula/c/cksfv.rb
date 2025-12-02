class Cksfv < Formula
  desc "File verification utility"
  homepage "https://zakalwe.fi/~shd/foss/cksfv/"
  url "https://zakalwe.fi/~shd/foss/cksfv/files/cksfv-1.3.15.tar.bz2"
  sha256 "a173be5b6519e19169b6bb0b8a8530f04303fe3b17706927b9bd58461256064c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://zakalwe.fi/~shd/foss/cksfv/files/"
    regex(/href=.*?cksfv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "98f4a00c83288bac3479fcd9e301409f3445d816bad334c6bd7632f302f8b638"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "96608dc540a21f5e14b2a1731b0d6350c00063db4528a1bcb56186188a157c00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25cb1cccb8aed81f49c5c9eee87e80c6148164a13060e59f429a61d91307a1c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0664f91348b09bb20a99e87161d8d54d4ea946ff10a1f4798098441b2f1badd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "581d29d48ab1ac605ffae68890cbd12419387331fdeb794f0055300a00af7ca5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a024ad7db7fd8bcc1ad251d6392963533b3d2733b3d9f1fa49dcdcdd11573b57"
    sha256 cellar: :any_skip_relocation, sonoma:         "89cb6ff3014a5bfb4616958a5970fb391432c8302547f97e5ecaec39fa2e5808"
    sha256 cellar: :any_skip_relocation, ventura:        "d03a7d8bb5705f8d841cc7353a0a81df246c8bcb081fb3006fa1441adf39e8d2"
    sha256 cellar: :any_skip_relocation, monterey:       "4d6559a12aabd7031e1a56b343681e73a378e3df6dd8eca6409089761c26e97a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a747f42a401eae71dd1931f2d09e8d215646f645ce3024a3702b6af36b22d242"
    sha256 cellar: :any_skip_relocation, catalina:       "9e0b05988d3af7d666d08c8d3f4d8792f043f899a88e689d819e0b1dfd4bc2b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6d94e6b9d42a2d3ce811f6cf4ed4d1a05cd76e8d77482362b0ee26dcf4c6598f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff8e6905611d7301b37271fdb5486d8d7598c4568a1035fe36269f7f97210723"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"foo"
    path.write "abcd"

    assert_match "#{path} ED82CD11", shell_output("#{bin}/cksfv #{path}")
  end
end
