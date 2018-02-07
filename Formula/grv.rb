class Grv < Formula
  desc "Terminal interface for viewing git repositories"
  homepage "https://github.com/rgburke/grv"
  url "https://github.com/rgburke/grv/releases/download/v0.1.2/grv-0.1.2-src.tar.gz"
  sha256 "81f06796b94791b2b4e10e5c92dabd91bcebab185747446c8f2974539e4ef001"
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
      system "make", "build-only"
      bin.install "grv"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grv -version")
  end
end
