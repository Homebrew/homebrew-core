class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://github.com/CISOfy/lynis/archive/3.0.6.tar.gz"
  sha256 "584ed6f6fa9dedeea1b473d888a4fe92fa9716400284fe41c92aed09cf10ec3e"
  license "GPL-3.0-only"

  livecheck do
    url "https://cisofy.com/downloads/lynis/"
    regex(%r{href=.*?/lynis[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc0a9524b52fc385fe438af0ec82772adffd8eb80fe8e54207130cb2945b1102"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc0a9524b52fc385fe438af0ec82772adffd8eb80fe8e54207130cb2945b1102"
    sha256 cellar: :any_skip_relocation, monterey:       "f22d1062214334e29b63165f7246ee32c64e9981ddc2ef15c9610f40da7e457c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f22d1062214334e29b63165f7246ee32c64e9981ddc2ef15c9610f40da7e457c"
    sha256 cellar: :any_skip_relocation, catalina:       "f22d1062214334e29b63165f7246ee32c64e9981ddc2ef15c9610f40da7e457c"
    sha256 cellar: :any_skip_relocation, mojave:         "f22d1062214334e29b63165f7246ee32c64e9981ddc2ef15c9610f40da7e457c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc0a9524b52fc385fe438af0ec82772adffd8eb80fe8e54207130cb2945b1102"
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
