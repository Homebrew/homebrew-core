class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.8.2.tar.gz"
  sha256 "0805e2e663a3d9702e80d12b5e9b54bafbecace08604cbd05e2121da30aaca17"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0406af870ba8a0856f55f84959c482f3233c4bf14034a1365f5e56bdbd1e8a4b" => :catalina
    sha256 "a80b912749b52c3468dc0a4d292dd08468ac3dc7e3f3e333f1e2ed86427ae3d1" => :mojave
    sha256 "b077a43b04365d028da6bdbd7876c8d21be347dfc3afb6f1dd9a5a1a4efe92da" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/mattn/jvgrep"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"jvgrep"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
