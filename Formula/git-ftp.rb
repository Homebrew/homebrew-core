class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/git-ftp"
  url "https://github.com/git-ftp/git-ftp/archive/1.3.3.tar.gz"
  sha256 "4e36ef178b498f273dc2e9b7685d28dea69b939dcf3602fdda69d1f525e24f31"

  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c15fc59bcde7f29f12b918f2abf62ff5a20675010ba384ba9a257f474c3c714" => :sierra
    sha256 "7c15fc59bcde7f29f12b918f2abf62ff5a20675010ba384ba9a257f474c3c714" => :el_capitan
    sha256 "7c15fc59bcde7f29f12b918f2abf62ff5a20675010ba384ba9a257f474c3c714" => :yosemite
  end

  option "with-manpage", "build and install the manpage (depends on pandoc)"

  depends_on "curl" => "with-libssh2"
  depends_on "pandoc" => :build if build.with? "manpage"

  def install
    system "make", "prefix=#{prefix}", "install"
    if build.with? "manpage"
      system "make", "-C", "man", "man"
      man1.install "man/git-ftp.1"
    end
    libexec.install bin/"git-ftp"
    (bin/"git-ftp").write <<-EOS.undent
      #!/bin/sh
      PATH=#{Formula["curl"].opt_bin}:$PATH
      #{libexec}/git-ftp "$@"
    EOS
  end

  test do
    system bin/"git-ftp", "--help"
  end
end
