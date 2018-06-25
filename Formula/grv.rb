class Grv < Formula
  desc "Terminal interface for viewing git repositories"
  homepage "https://github.com/rgburke/grv"
  url "https://github.com/rgburke/grv/releases/download/v0.2.0/grv-0.2.0-src.tar.gz"
  sha256 "4988bb0a74853ada3808d7c819bd159b2acee741baa1565e97033cd3118224b7"
  head "https://github.com/rgburke/grv.git"

  bottle do
    cellar :any
    sha256 "69468692838a2d4c1431bb8d45602301ee9b88118b8d3026ab49c843582d44d0" => :high_sierra
    sha256 "d69600ed8ca803e48f28ac57ee9a6bf7a8577bfecf71dd16ca25e79cd16a805a" => :sierra
    sha256 "db352c9768533ee682c220f25b033284c2bc7a7eda9d3a2a719752ef3670fc80" => :el_capitan
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
