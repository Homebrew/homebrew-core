class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "http://www.vervest.org/htp/"
  url "http://www.vervest.org/htp/archive/c/htpdate-1.2.2.tar.xz"
  sha256 "5f1f959877852abb3153fa407e8532161a7abe916aa635796ef93f8e4119f955"

  bottle do
    cellar :any_skip_relocation
    sha256 "4da5825b9f51a83c7de24d289719f0d341b79685a7e1580f2de867e53941934a" => :mojave
    sha256 "437b8823d451f79f1ad8e2420387a3f50c3dc5919ef19717d41c437a88b77247" => :high_sierra
  end

  depends_on :macos => :high_sierra # needs <sys/timex.h>

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end
