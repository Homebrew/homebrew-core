class Grumpy < Formula
  desc "Python to Go source code transcompiler and runtime"
  homepage "https://github.com/google/grumpy"
  head "https://github.com/google/grumpy.git"

  depends_on "go" => :build

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "install"
    system "mkdir", "-p", "#{bin}"
    system "cp", "#{prefix}/usr/bin/grumpc", "#{bin}"
    system "cp", "#{prefix}/usr/bin/grumprun", "#{bin}"
    system "echo", "Do 'brew test grumpy' to see sample usage"
    system "echo", "NOTE:  Before using grumpc and/or grumprun, you MUST:"
    system "echo", "export GOPATH=#{prefix}/usr/lib/go"
    system "echo", "export PYTHONPATH=#{prefix}/Library/Python/2.7/site-packages"
  end

  test do
    system "GOPATH=#{prefix}/usr/lib/go"
    system "PYTHONPATH=#{prefix}/Library/Python/2.7/site-packages"
    system "echo", "\"print 'hello, grumpy world'\"", "\|", "grumprun"
  end
end
