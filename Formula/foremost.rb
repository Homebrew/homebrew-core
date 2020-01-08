class Foremost < Formula
  desc "Console program to recover files based on their headers and footers"
  homepage "https://foremost.sourceforge.io/"
  url "https://foremost.sourceforge.io/pkg/foremost-1.5.7.tar.gz"
  sha256 "502054ef212e3d90b292e99c7f7ac91f89f024720cd5a7e7680c3d1901ef5f34"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3ce88077de06f1f58980822adeed92ca6db4b32bad5ed24aa3912dc8f0a1a47f" => :catalina
    sha256 "2255dbe5608916e081e46f1d332fcfc9b47265630827a472c4166daa061ea373" => :mojave
    sha256 "4411ec156c431a8715ba5d74f101c8f4e54793001424729dde2e305abf570558" => :high_sierra
  end

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr/", "#{prefix}/"
      s.change_make_var! "RAW_CC", ENV.cc
      s.change_make_var! "RAW_FLAGS", ENV.cflags
    end

    system "make", "mac"

    bin.install "foremost"
    man8.install "foremost.8.gz"
    etc.install "foremost.conf" => "foremost.conf.default"
  end

  test do
    system "#{bin}/foremost", "-V"
  end
end
