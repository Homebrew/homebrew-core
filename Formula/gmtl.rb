class Gmtl < Formula
  desc "Lightweight math library"
  homepage "https://ggt.sourceforge.io/"
  head "https://svn.code.sf.net/p/ggt/code/trunk"

  stable do
    url "https://downloads.sourceforge.net/project/ggt/Generic%20Math%20Template%20Library/0.6.1/gmtl-0.6.1.tar.gz"
    sha256 "f7d8e6958d96a326cb732a9d3692a3ff3fd7df240eb1d0921a7c5c77e37fc434"

    # Build assumes that Python is a framework, which isn't always true. See:
    # https://sourceforge.net/p/ggt/bugs/22/
    # The SConstruct from gmtl's HEAD doesn't need to be patched
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/gmtl/0.6.1.patch"
      sha256 "9c469bd61f5ab14820fed5b2fde7d71cbcc3b547c4a7100147d4c092ed80572a"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f69dd084cade396219047d066439043e0aaa689797082ee207db7a1335787286" => :mojave
    sha256 "66ae5e3ccd2a0cbf4608b4ffee45bccb9c3be33148af25787c76652c1c0967ac" => :high_sierra
    sha256 "ee8d0c9f5f52453421a189c040459b5126a5b739231493a3e39d331c934c6478" => :sierra
    sha256 "8aa9f0f1fb77376dd333bb03e9c5a07f6457b76008a74018a932dca930148606" => :el_capitan
    sha256 "5e6d70f957f11e58d8b3cd24d5474a8bedc73e0aec6df13f85322f4fda8a1164" => :mavericks
  end

  depends_on "scons" => :build

  # The scons script in gmtl only works for gcc, patch it
  # https://sourceforge.net/p/ggt/bugs/28/
  patch do
    url "https://gist.githubusercontent.com/anonymous/c16cad998a4903e6b3a8/raw/e4669b3df0e14996c7b7b53937dd6b6c2cbc7c04/gmtl_Sconstruct.diff"
    sha256 "1167f89f52f88764080d5760b6d054036734b26c7fef474692ff82e9ead7eb3c"
  end

  def install
    system "scons", "install", "prefix=#{prefix}"
  end
end
