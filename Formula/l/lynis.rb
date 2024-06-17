class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://github.com/CISOfy/lynis/archive/refs/tags/3.1.1.tar.gz"
  sha256 "ca38a27c9c92e78877be4ecffce25f3345a1d24bbcd68be66a3a600e2ff748d1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7a6bd2da4ca0d667474e50b56aea971b8f8005cc1671783b066670c0a51622a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7a6bd2da4ca0d667474e50b56aea971b8f8005cc1671783b066670c0a51622a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7a6bd2da4ca0d667474e50b56aea971b8f8005cc1671783b066670c0a51622a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9c8022b97c3540b39b3d305a597999600fe0a9f95fda0228c476c0276ee26da"
    sha256 cellar: :any_skip_relocation, ventura:        "b9c8022b97c3540b39b3d305a597999600fe0a9f95fda0228c476c0276ee26da"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c8022b97c3540b39b3d305a597999600fe0a9f95fda0228c476c0276ee26da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7a6bd2da4ca0d667474e50b56aea971b8f8005cc1671783b066670c0a51622a"
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
