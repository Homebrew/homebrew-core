class Grv < Formula
  desc "Terminal interface for viewing git repositories"
  homepage "https://github.com/rgburke/grv"
  url "https://github.com/rgburke/grv/releases/download/v0.3.1/grv-0.3.1-src.tar.gz"
  sha256 "604f927a40218f6d7dff2188f796bb47c4ababff203f11a6f7ebce2f1967b6f0"
  head "https://github.com/rgburke/grv.git"

  bottle do
    cellar :any
    sha256 "1330f549f1aad09f70f7173fdd0e108673b71adb85c37b539b448e31ebc02f90" => :mojave
    sha256 "a064e3eb5c0346b74f6e48270eb96a788970664671fbad2255b6d04499096b14" => :high_sierra
    sha256 "0da9d83d788502893b6ca9619b800b16787b3aeada2cf678996fc1b2ccd9f029" => :sierra
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
