class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.35.0/mk-configure-0.35.0.tar.gz"
  sha256 "7487cb26969f3e8f155c2a4d1b7d75599c60d593c10917462c1b505fa5a53bc1"

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a49f2ca0ced804d74bec13570685b119dfc3a9cf80414942d27fa646e3781c1b" => :big_sur
    sha256 "6953adbce89d8a07e95d89431881dbc3bf100e5de24ade46c409740db728fe8b" => :catalina
    sha256 "59821ba5bb3b8801fe52e309813b4edec6615a9698de164364ca8e723fa2ecb9" => :mojave
    sha256 "762f92188096b5c68bf6696a86310e6893829a67ca1bc3bf404fa931c6a7f48b" => :high_sierra
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system "#{bin}/mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end
