class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://github.com/CISOfy/lynis/archive/refs/tags/3.1.1.tar.gz"
  sha256 "ca38a27c9c92e78877be4ecffce25f3345a1d24bbcd68be66a3a600e2ff748d1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa42ff07a71b7ea74838c20577e452385f94dd7dbb8d1ef4da05c6f93cc63d28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa42ff07a71b7ea74838c20577e452385f94dd7dbb8d1ef4da05c6f93cc63d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa42ff07a71b7ea74838c20577e452385f94dd7dbb8d1ef4da05c6f93cc63d28"
    sha256 cellar: :any_skip_relocation, sonoma:         "6903141a385b893e605a512e2d9f2b3490fa3d89eedef375a1271cd72ce60142"
    sha256 cellar: :any_skip_relocation, ventura:        "6903141a385b893e605a512e2d9f2b3490fa3d89eedef375a1271cd72ce60142"
    sha256 cellar: :any_skip_relocation, monterey:       "6903141a385b893e605a512e2d9f2b3490fa3d89eedef375a1271cd72ce60142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa42ff07a71b7ea74838c20577e452385f94dd7dbb8d1ef4da05c6f93cc63d28"
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
