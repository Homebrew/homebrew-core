class Lxsplit < Formula
  desc "Tool for splitting or joining files"
  homepage "https://lxsplit.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lxsplit/lxsplit/0.2.4/lxsplit-0.2.4.tar.gz"
  sha256 "858fa939803b2eba97ccc5ec57011c4f4b613ff299abbdc51e2f921016845056"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e8aad7fc027ed1c5b9e42964483b596d5c1cfd98853f5d1cfb64a8f3155b98e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "af8c07cc79161f9f81048ef1dadeff7098887526cf5e178ae9d80383d2a2fa53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc985c81d249f7a8c5f38060e5e6e8c36bdb3a0aaa7c668fe44f18b587e4efcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4428d45c02da1ebb867b6319a97c9f6be29ee09cca1ad88f17c744427d864919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab46abecb79808403233fab3047c75f0ca630b4925d8c704a7bf087ef9ddc671"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a37c06c81b1160f5fee4c742537310afe07cccac1251384739f4340189ec4a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a4e4db3c7ba11af86422226f11e4d373e6c8e2a1b24831bcaca5910b1026f26"
    sha256 cellar: :any_skip_relocation, ventura:        "cc04acafa5e324481217f2ca6356f87e29418a169ba28042173be4650b8ee3af"
    sha256 cellar: :any_skip_relocation, monterey:       "5f89046f6987581afc236ac944ab9585136160a6f8f5d7f559a4fd18e45f43d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fc68ea7f529c0d6d5a5efb98f9644c93cfb6472798e1686a4384be56381bfcd"
    sha256 cellar: :any_skip_relocation, catalina:       "8f2c02d85a1aec1e2ec692564896c668cb6d7c4cd28b0d3b1f08da1be7070b07"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "25abf3d459e971588c1d58365ca4afdb710abd0a26a1dcdbb8470205e2d5bf9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5be1da254e8200601318c6258e63e4052dea5d43446d10872f8aab55e83abd4b"
  end

  def install
    bin.mkpath
    inreplace "Makefile", "/usr/local/bin", bin
    system "make"
    system "make", "install"
  end
end
