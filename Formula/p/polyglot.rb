class Polyglot < Formula
  desc "Protocol adapter to run UCI engines under XBoard"
  homepage "https://www.chessprogramming.org/PolyGlot"
  url "http://hgm.nubati.net/releases/polyglot-2.0.4.tar.gz"
  sha256 "c11647d1e1cb4ad5aca3d80ef425b16b499aaa453458054c3aa6bec9cac65fc1"
  license "GPL-2.0-or-later"
  head "http://hgm.nubati.net/git/polyglot.git", branch: "learn"

  livecheck do
    url "http://hgm.nubati.net/releases"
    regex(/href=.*?polyglot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6bf5814277c6a0cc6281f0d3e6911d909ef872edc68db77c9a382d17162020af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7c17a367c2d5da43b534695330ea6467fb27dcd887afeb6dc582601c4a6a5fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc554a6ab1946c530812eef33e2092102df23edfb12dcb14d98d288b5f15de96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d7bed90c3c1774a9a1765d8305b2fc0c9c38734a478777d35033570777f6a20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbcf961b5015dc2f909d421c6f1967a75110a44fa904718e599aa428341797d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74eb07a34cb1629966a192061f5ee507b8ff5db472b1fad9eeddba473b08570c"
    sha256 cellar: :any_skip_relocation, sonoma:         "84974144b7683943964b93e4686af237ef4a36f722b57e6c12dea8a78a65287c"
    sha256 cellar: :any_skip_relocation, ventura:        "719661c4cfbe1a0b809299d9285f4a715100783a6d2e7d8b89a5b3715ff4bb34"
    sha256 cellar: :any_skip_relocation, monterey:       "902514277b538f0d20c73875570832802028e7ba6c3f570ff0c2e4262625d7ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "96fe594c38129a85e97eed368154664e9e318fb16b3f97127a9a4e829ff47f39"
    sha256 cellar: :any_skip_relocation, catalina:       "2c29c3f2dd2547bfb05fc123f997ac118fae9fccb4354d151ecdb9f4d056c792"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9ad5fabb4324b9766a57bfb9889d17d2044e0f4ad9cdd8758e8fc968571919d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d78f2053c59df94cc0389beaf43906198ebc01dcb86c8cb888fdc6c640a9bc2"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(/^PolyGlot \d\.\d\.[0-9a-z]+ by Fabien Letouzey/, shell_output("#{bin}/polyglot --help"))
  end
end
