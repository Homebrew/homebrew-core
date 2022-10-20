class Mp3wrap < Formula
  desc "Wrap two or more mp3 files in a single large file"
  homepage "https://mp3wrap.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mp3wrap/mp3wrap/mp3wrap%200.5/mp3wrap-0.5-src.tar.gz"
  sha256 "1b4644f6b7099dcab88b08521d59d6f730fa211b5faf1f88bd03bf61fedc04e7"

  livecheck do
    url :stable
    regex(%r{url=.*?/mp3wrap[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a84d1acbd3aaa6432bf22d6052c1d8afa5b54145e1ecec0a16c6da05cf2df95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ee84cc1015ba99900a71896d7055b3fcf305828dc6a8430da552b0fee18a01b"
    sha256 cellar: :any_skip_relocation, monterey:       "e07fa1bc62342d8166accae07efd264b0449ee57ed27224f05897444bbec43fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb2198208b5da896231a815235652c3342ed305a858950c9fb10bc7e296d1e34"
    sha256 cellar: :any_skip_relocation, catalina:       "fa93ce86b2a055521e166325b4219773f04c6886075bd77932dcb6dff436ddce"
    sha256 cellar: :any_skip_relocation, mojave:         "ef3c37644b60e3644b2763a999ab189ceffe59d0506617db2d23cb3f3b430056"
    sha256 cellar: :any_skip_relocation, high_sierra:    "3c85e837e2dbcfcbbccb0b074ebfa9283c13d2453b206c246bc4d77600328dfb"
    sha256 cellar: :any_skip_relocation, sierra:         "0471701ab4f6b59423503b7c250376ba597a9f28d9962f6f9b35a107d58411ab"
    sha256 cellar: :any_skip_relocation, el_capitan:     "c65886799c1397eec33f48ef73774ad6a509fec44a18dec4a50c8755736f040a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e666ba56f6a93702e3a37b4dd6f8d908b6a16246ba9ad5467518c970f4ac30ab"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    source = test_fixtures("test.mp3")
    system "#{bin}/mp3wrap", "#{testpath}/t.mp3", source, source
    assert_predicate testpath/"t_MP3WRAP.mp3", :exist?
  end
end
