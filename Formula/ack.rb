class Ack < Formula
  desc "Search tool like grep, but optimized for programmers"
  homepage "https://beyondgrep.com/"
  url "https://beyondgrep.com/ack-2.18-single-file"
  version "2.18"
  sha256 "6e41057c8f50f661d800099471f769209480efa53b8a886969d7ec6db60a2208"
  head "https://github.com/petdance/ack2.git", :branch => "dev"

  bottle :unneeded

  resource "File::Next" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/File-Next-1.12.tar.gz"
    sha256 "cc3afd8eaf6294aba93b8152a269cc36a9df707c6dc2c149aaa04dabd869e60a"
  end

  def install
    if build.stable?
      bin.install "ack-#{version}-single-file" => "ack"
      system "pod2man", "#{bin}/ack", "ack.1"
      man1.install "ack.1"
    else
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
    end
  end

  test do
    assert_equal "foo bar\n", pipe_output("#{bin}/ack --noenv --nocolor bar -",
                                          "foo\nfoo bar\nbaz")
  end
end
