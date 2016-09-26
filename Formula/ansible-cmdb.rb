class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.16/ansible-cmdb-1.16.zip"
  sha256 "4839b19577ffc07b2d47cc8a73ef82ead28836a575cb2293042171041fe1c96c"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bdd17378c48f20976b1ce2dbc77f4677be2ae9df0eaf3041634c9d454bfda27" => :sierra
    sha256 "42647ac67f2b0174df05cc1e2c4cf655264a7d65da5c6576265209c39815bc65" => :el_capitan
    sha256 "69ceac2289853d06e4cbd19ad8a1026ecc77b1921e22a559a61fc450ba9a33a9" => :yosemite
    sha256 "69ceac2289853d06e4cbd19ad8a1026ecc77b1921e22a559a61fc450ba9a33a9" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  def install
    bin.mkpath
    man1.mkpath
    inreplace "Makefile" do |s|
      s.gsub! "/usr/local/lib/${PROG}", prefix
      s.gsub! "/usr/local/bin", bin
      s.gsub! "/usr/local/share/man/man1", man1
    end
    system "make", "install"
  end

  test do
    system bin/"ansible-cmdb", "-dt", "html_fancy", "."
  end
end
