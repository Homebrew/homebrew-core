class Ack < Formula
  desc "Search tool like grep, but optimized for programmers"
  homepage "https://beyondgrep.com/"
  url "https://beyondgrep.com/ack-v3.6.0"
  sha256 "436c4ef67a99a60e1fd119e24c0f3eec8f97b5914cc36fe960ebab71045a21c7"
  license "Artistic-2.0"

  livecheck do
    url "https://beyondgrep.com/install/"
    regex(/href=.*?ack[._-]v?(\d+(?:\.\d+)+)["' >]/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e7e30bf5bbecf500fe23c4c3bcaf4fbf0e7976e902df2b4e16bcbd10898d13b0"
  end

  head do
    url "https://github.com/beyondgrep/ack3.git", branch: "dev"

    resource "File::Next" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/File-Next-1.16.tar.gz"
      sha256 "6965f25c2c132d0ba7a6f72b57b8bc6d25cf8c1b7032caa3a9bda8612e41d759"
    end
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

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
      (bin/"ack").write_env_script("#{libexec}/ack", PERL5LIB: ENV["PERL5LIB"])
      man1.install "blib/man1/ack.1"
    else
      bin.install "ack-v#{version.to_s.tr("-", "_")}" => "ack"
      system "#{Formula["pod2man"].opt_bin}/pod2man", "#{bin}/ack", "ack.1", "--release=ack v#{version}"
      man1.install "ack.1"
    end
  end

  test do
    assert_equal "foo bar\n", pipe_output("#{bin}/ack --noenv --nocolor bar -",
                                          "foo\nfoo bar\nbaz")
  end
end
