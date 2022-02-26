class Bubblewrap < Formula
  desc "Unprivileged sandboxing tool for Linux"
  homepage "https://github.com/containers/bubblewrap"
  url "https://github.com/containers/bubblewrap/releases/download/v0.6.1/bubblewrap-0.6.1.tar.xz"
  sha256 "9609c7dc162bc68abc29abfab566934fdca37520a15ed01b675adcf3a4303282"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d846c3f5d6c39da9eb28833ad84a01aa3fd4f711644665ad3b9a7db1b8ff5a02"
  end

  head do
    url "https://github.com/containers/bubblewrap.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "libxslt"     => :build
  depends_on "strace" => :test
  depends_on "libcap"
  depends_on :linux

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules",
           "--with-bash-completion-dir=#{bash_completion}"

    # Use docbook-xsl's docbook style for generating the man pages:
    inreplace "Makefile" do |s|
      s.gsub! "http://docbook.sourceforge.net/release/xsl/current",
              "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    end

    system "make", "install"
  end

  test do
    assert_match "bubblewrap", "#{bin}/bwrap --version"
    assert_match "clone", shell_output("strace -e inject=clone:error=EPERM " \
                                       "#{bin}/bwrap --bind / / /bin/echo hi 2>&1", 1)
  end
end
