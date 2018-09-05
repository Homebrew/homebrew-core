class Hilite < Formula
  desc "CLI tool that runs a command and highlights STDERR output"
  homepage "https://sourceforge.net/projects/hilite/"
  url "https://downloads.sourceforge.net/project/hilite/hilite/1.5/hilite.c"
  sha256 "e15bdff2605e8d23832d6828a62194ca26dedab691c9d75df2877468c2f6aaeb"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b25a0fe83ce681fab4f9a0a3f7989528387e299cd6fc507eeb9b24e8f2b1490" => :mojave
    sha256 "0266c20b3be69d398a14f1cb9332d34fe9ffca36c827b6e3681b636c0eab6073" => :high_sierra
    sha256 "b4bab9fd50310b7401d2605b9a9cdad0a8d7069e5b477d5f53fef61847bea624" => :sierra
    sha256 "2c407d12952089ade6602be85acda46eceb3127e32ba2068c0034df8a486e989" => :el_capitan
    sha256 "1eea4240f83568d245aa55801949cd9deb4663fc26df75569e029cc1c4c14112" => :yosemite
    sha256 "d004176bb8c9df0a165c05863d594e007831cc6b9ce4219ec3639b4ba1069895" => :mavericks
  end

  def install
    system ENV.cc, ENV.cflags, "hilite.c", "-o", "hilite"
    bin.install "hilite"
  end

  test do
    system "#{bin}/hilite", "bash", "-c", "echo 'stderr in red' >&2"
  end
end
