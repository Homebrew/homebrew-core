class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://github.com/CISOfy/lynis/archive/refs/tags/3.1.0.tar.gz"
  sha256 "bc197423b5767d42e8ae5fabc9eb40c494af9ff1543d3679cbfb97a3ba72f20e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f286611cd75569c254b277018a249a9826c71f276ea1ed2cb2dd53265f6f0e9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f286611cd75569c254b277018a249a9826c71f276ea1ed2cb2dd53265f6f0e9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f286611cd75569c254b277018a249a9826c71f276ea1ed2cb2dd53265f6f0e9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f286611cd75569c254b277018a249a9826c71f276ea1ed2cb2dd53265f6f0e9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b611779c1dc232183529386a76a47492aa2a1424220d9e002317e1a79271cebd"
    sha256 cellar: :any_skip_relocation, ventura:        "b611779c1dc232183529386a76a47492aa2a1424220d9e002317e1a79271cebd"
    sha256 cellar: :any_skip_relocation, monterey:       "b611779c1dc232183529386a76a47492aa2a1424220d9e002317e1a79271cebd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b611779c1dc232183529386a76a47492aa2a1424220d9e002317e1a79271cebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f42606a32b9515dd1dadcf130071dae101cc108dd758fe01ba0c95d447f3954c"
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
