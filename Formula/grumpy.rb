class Grumpy < Formula
  desc "Python to Go source code transcompiler and runtime"
  homepage "https://github.com/google/grumpy"
  head "https://github.com/google/grumpy.git"

  depends_on "go"

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "install"
    bin.install "#{prefix}/usr/bin/grumpc"
    bin.install "#{prefix}/usr/bin/grumprun"
  end

  def caveats
    <<-EOS.undent
      NOTE:  Before using grumpc and/or grumprun, you MUST:
      export GOPATH="$(brew --prefix grumpy)/usr/lib/go"
      export PYTHONPATH="$(brew --prefix grumpy)/Library/Python/2.7/site-packages"

      Then you can test out grumpy with:
      echo "print 'hello, grumpy world'" | grumprun
    EOS
  end

  test do
    ENV["GOPATH"] = "#{prefix}/usr/lib/go"
    ENV["PYTHONPATH"] = "#{prefix}/Library/Python/2.7/site-packages"
    system "echo", "\"print 'hello, grumpy world'\"", "\|", "grumprun"
  end
end
