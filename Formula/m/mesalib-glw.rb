class MesalibGlw < Formula
  desc "Open-source implementation of the OpenGL specification"
  homepage "https://www.mesa3d.org"
  url "https://archive.mesa3d.org/glw/glw-8.0.0.tar.bz2"
  sha256 "2da1d06e825f073dcbad264aec7b45c649100e5bcde688ac3035b34c8dbc8597"
  license "SGI-OpenGL"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d14b295f394354aa03fc3f890ae631455970b93cf1429c2478efc3a10b43c28b"
    sha256 cellar: :any,                 arm64_sequoia:  "b127d5bb8ec7caceb1de9e05a28bf845242e04886ad39357558704b9ffd51e9b"
    sha256 cellar: :any,                 arm64_sonoma:   "e36a490fd422b17fc371870a0da3c657520cc1e90bb01a865c1356a6bb466acd"
    sha256 cellar: :any,                 arm64_ventura:  "a9fdf656540dc268519f8e3fded305c1e86c4690cf7cfa5571e3edbee9e56cc5"
    sha256 cellar: :any,                 arm64_monterey: "f19366ec40b0666882b3d10a0e6635ecc25e75446a85bb695f44ccaf35ca809a"
    sha256 cellar: :any,                 arm64_big_sur:  "fed357436c36aa832c46cad896d75a9b3f0015658732af9cad3a18b19769ea72"
    sha256 cellar: :any,                 sonoma:         "560adfd13999ca45b56b3de6c9f3b071639b09a3b386add75b64db6f0d7eea74"
    sha256 cellar: :any,                 ventura:        "04daf708d2f8327ba0ae42652d4b6d332fd560cdcf6c7ac9b09140bd0ced8a67"
    sha256 cellar: :any,                 monterey:       "a94da8b984b2f2f08057324d812b03bbd8108f541b409f481e4ea41d4323df30"
    sha256 cellar: :any,                 big_sur:        "9580a442aa0843b284317be696caa8742165a1574d20e8398c9fadbdfc426dc6"
    sha256 cellar: :any,                 catalina:       "1a1690918045f775ea6d71216a5b674b5762556aeaf0285e70533150aa7f14b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "804dfa5c3d312c8b55d18b3665b5608ac7cd86440423718bfea467f069141c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7ca035e7cb0fb4bb11fc7978a33f619b1adfb06678260f70df6b79f6dfcd91a"
  end

  # Official[^1] git repository has been archived[^2]
  #
  # [^1]: https://docs.mesa3d.org/faq.html?highlight=glw#where-is-the-glw-library
  # [^2]: https://gitlab.freedesktop.org/mesa/glw
  deprecate! date: "2024-10-09", because: :repo_archived
  disable! date: "2025-10-09", because: :repo_archived

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxt"
  depends_on "mesa"

  def install
    args = []
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end
