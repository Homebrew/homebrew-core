class Lxsplit < Formula
  desc "Tool for splitting or joining files"
  homepage "https://lxsplit.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lxsplit/lxsplit/0.2.4/lxsplit-0.2.4.tar.gz"
  sha256 "858fa939803b2eba97ccc5ec57011c4f4b613ff299abbdc51e2f921016845056"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4428d45c02da1ebb867b6319a97c9f6be29ee09cca1ad88f17c744427d864919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab46abecb79808403233fab3047c75f0ca630b4925d8c704a7bf087ef9ddc671"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a37c06c81b1160f5fee4c742537310afe07cccac1251384739f4340189ec4a2"
    sha256 cellar: :any_skip_relocation, ventura:        "cc04acafa5e324481217f2ca6356f87e29418a169ba28042173be4650b8ee3af"
    sha256 cellar: :any_skip_relocation, monterey:       "5f89046f6987581afc236ac944ab9585136160a6f8f5d7f559a4fd18e45f43d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fc68ea7f529c0d6d5a5efb98f9644c93cfb6472798e1686a4384be56381bfcd"
    sha256 cellar: :any_skip_relocation, catalina:       "8f2c02d85a1aec1e2ec692564896c668cb6d7c4cd28b0d3b1f08da1be7070b07"
    sha256 cellar: :any_skip_relocation, mojave:         "ffc9b9b7e9669e1cff8a46b3930d052ffa149179897134439b1228d8ee178777"
    sha256 cellar: :any_skip_relocation, high_sierra:    "da1b73f5843b77ce947ce546fb77a47f2c1b989efbf70fdd61b9d05f81a386b5"
    sha256 cellar: :any_skip_relocation, sierra:         "f4d271c94546ca73b9e5262ff53bf7b51dcde2a83998d5a2e4b663109f2f69d8"
    sha256 cellar: :any_skip_relocation, el_capitan:     "25699d54183a01f446015fb02521a50b3967ef2d250e56bb1fe3fd0a5aaec2e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5be1da254e8200601318c6258e63e4052dea5d43446d10872f8aab55e83abd4b"
  end

  def install
    bin.mkpath
    inreplace "Makefile", "/usr/local/bin", bin
    system "make"
    system "make", "install"
  end
end
