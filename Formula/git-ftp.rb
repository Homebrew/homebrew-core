class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/git-ftp"
  url "https://github.com/git-ftp/git-ftp/archive/1.2.0.tar.gz"
  sha256 "c0279c85f3f8533eb47e24d3ba9055af3804c613cc9076b7901bf7a1da82a95c"

  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbb14b73d5735c834c32c698e3243cfe9630e84da60a46103512b74d69d300a8" => :el_capitan
    sha256 "b0bdb187af00eb6170de462d95a8dcdcd48e0aac445c26545ae4107e3b4ad608" => :yosemite
    sha256 "cce74cf54124ae85fc250a6d78c338f9a3803852ebc089445c78cb183a482abb" => :mavericks
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
