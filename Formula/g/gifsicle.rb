class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.94.tar.gz"
  sha256 "4bc97005c0789620de75f89997d3c2f70758c72c61aa0a2ef04f7a671a2ff89b"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?gifsicle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "495dd66c7ddd1b299a4c5749e36b2f67025551107a53373cceb62a9edd352679"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c105096a7b6e2fe2b8e1e68f33b5fd9fb1439383f92cc9469c00434ae36eaf36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd69deb29df96f9327a72edbac71fc719006787ae8630ff3e7d67ba056187dfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e983d19c371eab70ca7dad2fe50067ff5450affd6ce1dc803a972fecd85b9519"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7e8f7ffe999cdb7ac0adf5c989e7f42b231c38b46a682008c4b23a62afd6763"
    sha256 cellar: :any_skip_relocation, ventura:        "3e391689dd86d9910efd00ab6524102285b5c805fba4cdc4e9c4fcc01881adf3"
    sha256 cellar: :any_skip_relocation, monterey:       "d55bd5ebf7e9ba6c7e59979b881399977e8b504cb89dc5fda8c4b17f61758add"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8af233917b64be70b99004d42d1781e3d2af4073814cab62d36cc50ca1a68f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af1ed4002d85c1a874ba73365cf5f1bccf366bd9a4a5fce7edd01ad5eb7461d8"
  end

  head do
    url "https://github.com/kohler/gifsicle.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gifview
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gifsicle", "--info", test_fixtures("test.gif")
  end
end
