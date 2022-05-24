class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://github.com/CISOfy/lynis/archive/3.0.8.tar.gz"
  sha256 "0315da29e382281daa1db24c8494ca12659c7387d9cd30222adcf1aa01383730"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "590b7e427e36b3613b725b7d2e32ea45f9dcee911c46be70347be5c3ebc1e3ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "590b7e427e36b3613b725b7d2e32ea45f9dcee911c46be70347be5c3ebc1e3ba"
    sha256 cellar: :any_skip_relocation, monterey:       "f43da37593963aba57890c739e944505c5ccc6ef78b2cf19255c8c9748c69894"
    sha256 cellar: :any_skip_relocation, big_sur:        "f43da37593963aba57890c739e944505c5ccc6ef78b2cf19255c8c9748c69894"
    sha256 cellar: :any_skip_relocation, catalina:       "f43da37593963aba57890c739e944505c5ccc6ef78b2cf19255c8c9748c69894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "590b7e427e36b3613b725b7d2e32ea45f9dcee911c46be70347be5c3ebc1e3ba"
  end

  def install
    inreplace "lynis" do |s|
      s.gsub! 'tINCLUDE_TARGETS="/usr/local/include/lynis ' \
              '/usr/local/lynis/include /usr/share/lynis/include ./include"',
              %Q(tINCLUDE_TARGETS="#{include}")
      s.gsub! 'tPLUGIN_TARGETS="/usr/local/lynis/plugins ' \
              "/usr/local/share/lynis/plugins /usr/share/lynis/plugins " \
              '/etc/lynis/plugins ./plugins"',
              %Q(tPLUGIN_TARGETS="#{prefix}/plugins")
      s.gsub! 'tDB_TARGETS="/usr/local/share/lynis/db /usr/local/lynis/db ' \
              '/usr/share/lynis/db ./db"',
              %Q(tDB_TARGETS="#{prefix}/db")
    end
    inreplace "include/functions" do |s|
      s.gsub! 'tPROFILE_TARGETS="/usr/local/etc/lynis /etc/lynis ' \
              '/usr/local/lynis ."',
              %Q(tPROFILE_TARGETS="#{prefix}")
    end

    prefix.install "db", "include", "plugins", "default.prf"
    bin.install "lynis"
    man8.install "lynis.8"
  end

  test do
    assert_match "lynis", shell_output("#{bin}/lynis --invalid 2>&1", 64)
  end
end
