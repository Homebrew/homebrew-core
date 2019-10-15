class Grv < Formula
  desc "Terminal interface for viewing git repositories"
  homepage "https://github.com/rgburke/grv"
  url "https://github.com/rgburke/grv/releases/download/v0.3.2/grv-0.3.2-src.tar.gz"
  sha256 "988788cce5c581531c26df9048e4187440c5ebc9811afd371d565436dfb65d57"
  head "https://github.com/rgburke/grv.git"

  bottle do
    cellar :any
    sha256 "47ca79fcad09617a086eddf37627be483b9d6ca9a2436d11acac6754b0d2ce15" => :catalina
    sha256 "2f223f7ca56ee01201a05e8660c219a2f70d7ead2c5e4f0dac65f4a9b8cd5941" => :mojave
    sha256 "d51249eec72ee11cc90b0d5b4c06e10b77eec0bd7ddf8b53df6d0a0d8a291605" => :high_sierra
    sha256 "19f2e8bedb458d0b339160b275e196add00abcca7db92ba141aaccae255bb973" => :sierra
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
