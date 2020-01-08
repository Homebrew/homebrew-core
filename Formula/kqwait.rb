class Kqwait < Formula
  desc "Wait for events on files or directories on macOS"
  homepage "https://github.com/sschober/kqwait"
  url "https://github.com/sschober/kqwait/archive/kqwait-v1.0.3.tar.gz"
  sha256 "878560936d473f203c0ccb3d42eadccfb50cff15e6f15a59061e73704474c531"
  head "https://github.com/sschober/kqwait.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a126094dabbb2fd9a2c539b1515657c1855bb0c971492ca0d6c56aa97bfebe48" => :catalina
    sha256 "474c5ae5f69ca9a2a239d601733b88ad2eeca8701bae1b5431385bb05fff6b24" => :mojave
    sha256 "dff2354e240808ec604ebd457c45ca9f2fe540fc235fc30c71c7d4effae5d0a3" => :high_sierra
    sha256 "cdf423b95df66f4875df6355e1bef51c41132d1de83205d2a1f87663be5edfb8" => :sierra
    sha256 "889401570c96026d7e343d48165cd2bc61735678e0125902e7d36680fa64d9a9" => :el_capitan
    sha256 "c65e153f40c8f7a3e8732f4cb386e2758cdff079e7600524011ca7c6d1da4a0d" => :yosemite
    sha256 "12b37969bfe8cabc32eef282d25cab5c5f973f91d29345c9d1a6ea9a61de0c68" => :mavericks
  end

  def install
    system "make"
    bin.install "kqwait"
  end

  test do
    system "#{bin}/kqwait", "-v"
  end
end
