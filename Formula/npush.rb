class Npush < Formula
  desc "Logic game simliar to Sokoban and Boulder Dash"
  homepage "http://npush.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/npush/npush/0.7/npush-0.7.tgz"
  sha256 "f216d2b3279e8737784f77d4843c9e6f223fa131ce1ebddaf00ad802aba2bcd9"
  head "svn://svn.code.sf.net/p/npush/code/"

  bottle do
    cellar :any_skip_relocation
    sha256 "6813b07cd32089c5c41d04375233270f8a61d26dfcb41f82a50063c995a562bc" => :el_capitan
    sha256 "b54aafd290ef5872b8b4737165639cb7a670902bee8bbb52422913c40aae0e94" => :yosemite
    sha256 "3959d2c4f0a9e7525e18f44a25e5208388979bcf97a4896570766f4f29c8b1d9" => :mavericks
  end

  def install
    system "make"
    pkgshare.install ["npush", "levels"]
    (bin/"npush").write <<-EOS.undent
      #!/bin/sh
      cd "#{pkgshare}" && exec ./npush $@
      EOS
  end
end
