class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.39.3/mk-configure-0.39.3.tar.gz"
  sha256 "399345da4d45fffb1aef0051e09512e1661d06bd6cdf2691c3aef0ead05f39a2"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee217b772055a5c95ecb6e13a9da288d226985cdde07f010c7e74d8c3f3fec1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "917b28de7453c56cdb3c06a075e201fc96345a65e20b442d2b3109cba67bfc5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "120b9504282071180d6538f6f6a847b7c8ac0374850a7b8928f9fe2dd4c55f9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "92c9fe410739a63e26ae49eb4b6dde02f0e54a2da18315e867d3bb1757bd94e2"
    sha256 cellar: :any_skip_relocation, ventura:        "edacda193dd2032c9fc58935be11b14c94a5de8dee93da85f831087db29b2f38"
    sha256 cellar: :any_skip_relocation, monterey:       "07fe412cf4d1fcff24325bbdb67ef066f3f9c8f8b29a34de26d273154df21153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2dc6975e6eac40d2c18e9aab376f003c5a6ece2f543aea4b076cc9dff508fb5"
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
