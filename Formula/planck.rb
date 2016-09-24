class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.17.tar.gz"
  sha256 "f088acecc25412f901b512478d9fd5acf38c1ff0276f18d45f78ad9a5ce37596"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d670247f5e9010f363d0c4743b188dd0dd46192f3070d6a1b97aa60071040610" => :sierra
    sha256 "338db78620d60b90ee0ab18b32873a1b17782948c57d5cfc074d3e902380013e" => :el_capitan
    sha256 "4544586aa9c310f34060dba25a4cd558aa70c1863f5303aae8ed7c7602d110d9" => :yosemite
    sha256 "237e29161849ae72add25713a1e6ce3d3aab357f887cd4864fe10bdde266be35" => :mavericks
  end

  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "build/Release/planck"
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
