class Kqwait < Formula
  desc "Wait for events on files or directories on macOS"
  homepage "https://github.com/sschober/kqwait"
  url "https://github.com/sschober/kqwait/archive/kqwait-v1.0.3.tar.gz"
  sha256 "878560936d473f203c0ccb3d42eadccfb50cff15e6f15a59061e73704474c531"
  license "BSD-2-Clause"
  head "https://github.com/sschober/kqwait.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "647d43de225f13a8d44c1b496bea51d180645b5c51cee5de9c82484117549d7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfd6026d7a40557bb6e2e660af989426984359a1a18af842237b46a7b8af10b7"
    sha256 cellar: :any_skip_relocation, monterey:       "f348cb75f4cc2ebc25a690de447dee670a144707256a08a252454d27fe52a042"
    sha256 cellar: :any_skip_relocation, big_sur:        "d628f1544a08964c38352d12b7d7c8eab0317391e7eceab195d11882852b4ee3"
    sha256 cellar: :any_skip_relocation, catalina:       "a126094dabbb2fd9a2c539b1515657c1855bb0c971492ca0d6c56aa97bfebe48"
    sha256 cellar: :any_skip_relocation, mojave:         "474c5ae5f69ca9a2a239d601733b88ad2eeca8701bae1b5431385bb05fff6b24"
    sha256 cellar: :any_skip_relocation, high_sierra:    "dff2354e240808ec604ebd457c45ca9f2fe540fc235fc30c71c7d4effae5d0a3"
    sha256 cellar: :any_skip_relocation, sierra:         "cdf423b95df66f4875df6355e1bef51c41132d1de83205d2a1f87663be5edfb8"
    sha256 cellar: :any_skip_relocation, el_capitan:     "889401570c96026d7e343d48165cd2bc61735678e0125902e7d36680fa64d9a9"
    sha256 cellar: :any_skip_relocation, yosemite:       "c65e153f40c8f7a3e8732f4cb386e2758cdff079e7600524011ca7c6d1da4a0d"
  end

  def install
    system "make"
    bin.install "kqwait"
  end

  test do
    system "#{bin}/kqwait", "-v"
  end
end
