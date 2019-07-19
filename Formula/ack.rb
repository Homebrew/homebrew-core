class Ack < Formula
  desc "Search tool like grep, but optimized for programmers"
  homepage "https://beyondgrep.com/"
  url "https://beyondgrep.com/ack-v3.0.2"
  sha256 "8e49c66019af3a5bf5bce23c005231b2980e93889aa047ee54d857a75ab4a062"

  head do
    url "https://github.com/petdance/ack2.git", :branch => "dev"

    resource "File::Next" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/File-Next-1.16.tar.gz"
      sha256 "6965f25c2c132d0ba7a6f72b57b8bc6d25cf8c1b7032caa3a9bda8612e41d759"
    end
  end

  bottle :unneeded

  def install
    if build.head?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV.prepend_path "PERL5LIB", libexec/"lib"

      resource("File::Next").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end

      system "perl", "Makefile.PL", "DESTDIR=#{buildpath}"
      system "make"

      libexec.install "ack"
      chmod 0755, libexec/"ack"
      (libexec/"lib").install "blib/lib/App"
      (bin/"ack").write_env_script("#{libexec}/ack", :PERL5LIB => ENV["PERL5LIB"])
      man1.install "blib/man1/ack.1"
    else
      bin.install "ack-v#{version.to_s.tr("-", "_")}" => "ack"
      system "pod2man", "#{bin}/ack", "ack.1"
      man1.install "ack.1"
    end
  end

  test do
    assert_equal "foo bar\n", pipe_output("#{bin}/ack --noenv --nocolor bar -",
                                          "foo\nfoo bar\nbaz")
  end
end
