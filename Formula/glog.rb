class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.3.5.tar.gz"
  sha256 "7580e408a2c0b5a89ca214739978ce6ff480b5e7d8d7698a2aa92fadc484d1e0"
  revision 1

  bottle do
    cellar :any
    sha256 "a3e0adb8c4bd45b73b6200b2e503e55bd59749e45ce31b90f72bb11bd341d427" => :sierra
    sha256 "1fc76882e8bb6f5fea7f1479e89e09c7b4e82dd4130d0a0fb12dbc948a805166" => :el_capitan
    sha256 "253d15bc60962e7f9a9bb77eddebc0153c3f8895b5e06dadb0ddad4bb97b4c09" => :yosemite
  end

  depends_on "gflags"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
