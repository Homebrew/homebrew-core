class Ii < Formula
  desc "Minimalist IRC client"
  homepage "http://tools.suckless.org/ii"
  url "http://dl.suckless.org/tools/ii-1.7.tar.gz"
  sha256 "3a72ac6606d5560b625c062c71f135820e2214fed098e6d624fc40632dc7cc9c"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "94552db0ec06e1266deac0ec19e5d67de8d1bcb9028aac7230e54c60d89f6d82" => :el_capitan
    sha256 "80269185a9b95dbe935859d056ba4f1510210f639a27aff6a5bfc2e847d7d985" => :yosemite
    sha256 "5be7e1ba2e3dddf0d8700366c2ebee273c6c570fc4d6e20655d0bd9219478e9b" => :mavericks
  end

  head "http://git.suckless.org/ii", :using => :git

  def install
    inreplace "config.mk" do |s|
      s.gsub! "/usr/local", prefix
      s.gsub! "cc", ENV.cc
    end
    system "make", "install"
  end
end
