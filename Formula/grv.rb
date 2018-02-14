class Grv < Formula
  desc "Terminal interface for viewing git repositories"
  homepage "https://github.com/rgburke/grv"
  url "https://github.com/rgburke/grv/releases/download/v0.1.2/grv-0.1.2-src.tar.gz"
  sha256 "1f2f8adb28085fd892f4b23cf5cf17925fc502cf479be35193e1c6b93cad1e49"
  head "https://github.com/rgburke/grv.git"

  bottle do
    cellar :any
    sha256 "62e0a634c2aaa42b878df3a242a5b5dc8237b1d40bd1b6e7047cc5fda935f435" => :high_sierra
    sha256 "c4d62bd5c73511a1eacd623dcfad70a481835675b3d57e340971fc230bf5f7b8" => :sierra
    sha256 "cac9d24abc2693f9457e3af37fb7717c13641da063b669b88aa3a2ae3aa14c37" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/rgburke/grv"
    path.install buildpath.children

    cd path do
      system "make", "build-only"
      bin.install "grv"
      prefix.install_metafiles
    end
  end

  test do
    ENV["TERM"] = "xterm"

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "test"
    pipe_output("#{bin}/grv -logLevel DEBUG", "'<grv-exit>'", 0)

    assert_predicate testpath/"grv.log", :exist?
    assert_match "Loaded HEAD", File.read(testpath/"grv.log")
  end
end
