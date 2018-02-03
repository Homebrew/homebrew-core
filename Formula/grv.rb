class Grv < Formula
  desc "Terminal interface for viewing git repositories"
  homepage "https://github.com/rgburke/grv"
  url "https://github.com/rgburke/grv/releases/download/v0.1.1/grv-0.1.1-src.tar.gz"
  sha256 "5cb2a9a35b492df8ad188a294c41a1aecb7d293a0d5241f5e16f8c2613333a15"
  head "https://github.com/rgburke/grv.git"

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "readline"

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/rgburke/grv"
    path.install buildpath.children

    cd path do
      system "make"
      bin.install "grv"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grv -version")
  end
end
