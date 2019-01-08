class Grv < Formula
  desc "Terminal interface for viewing git repositories"
  homepage "https://github.com/rgburke/grv"
  url "https://github.com/rgburke/grv/releases/download/v0.3.1/grv-0.3.1-src.tar.gz"
  sha256 "604f927a40218f6d7dff2188f796bb47c4ababff203f11a6f7ebce2f1967b6f0"
  head "https://github.com/rgburke/grv.git"

  bottle do
    cellar :any
    sha256 "62519263db387ddbfbdbe3e6125d378137a3ff804a4e767c6057701ec7e0dfb4" => :mojave
    sha256 "f78ead35f6f7c87d8102202832c3ece1cbc8a31a8696bb79f1ba04bab9680999" => :high_sierra
    sha256 "b7f28599d6bb4159e82b1b0c9f9bc24b6351054ae0fab9e449eef3b09e1e3b80" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
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
