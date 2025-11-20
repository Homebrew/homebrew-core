class Ccd2iso < Formula
  desc "Convert CloneCD images to ISO images"
  homepage "https://ccd2iso.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccd2iso/ccd2iso/ccd2iso-0.3/ccd2iso-0.3.tar.gz"
  sha256 "f874b8fe26112db2cdb016d54a9f69cf286387fbd0c8a55882225f78e20700fc"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b0fdfe74cdd573d4b411974eb51ff6d8dd0be85e2ca817a42517d7651f21f638"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e7196c00e29751b4d90307dcc66d0d0f329dcce6bc4c9ce9ae88aceef81e55ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c3859a54807a7d37e25bf568c22dd063ad9d613713242cc8e266e69f985cc59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e1e557828fbb5b8b991d0710a5e2489a82bc8dad3b6136d2ddd17f2ced86c5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a6f9de23756982dfeb30537a00671d0a3d51edb2e322a9d4285c3a89da3be63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5744e3d028a63b27e0a6b9c8f0c839effbd4385f41af50bb44725d5310b61ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "4783fb7a6000284fc3d8e6e1bdd1a6ee87cd1f92428412e6f436344903ccf28b"
    sha256 cellar: :any_skip_relocation, ventura:        "3fd3ad509a9207e16d00d0b00d34a3ee7b15318303d1a1ec5e94ddf40785e8d8"
    sha256 cellar: :any_skip_relocation, monterey:       "16d7cbbc96fab04752d418f7e4f196e2d0d36e494a27002bf76f907d160cba50"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bd1d2fedb8cd0bfe682f80bffeced5c7e273a2d24c2dd01a7b777e4d3ee0115"
    sha256 cellar: :any_skip_relocation, catalina:       "741bb587861701e9900ede511e2db1e73815428eb2f0f2c697313dad70609853"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "929e63160bead9e5533fea39f455a370513e0879b1c66205b570ef1f87e9feea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eca2835beb5b622b6f0b2b781524e638e67a65b8d4f683cb0984c74c34c1603b"
  end

  def install
    # Missing <string.h> header file, see https://sourceforge.net/p/ccd2iso/bugs/11/
    inreplace "src/ccd2iso.c", "#include <stdlib.h>\n", "#include <stdlib.h>\n#include <string.h>\n"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(
      /^#{Regexp.escape(version)}$/, shell_output("#{bin}/ccd2iso --version")
    )
  end
end
