class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
    :tag => "v1.3.0",
    :revision => "fad95c028a3d4d783282f5545a4a676dfec7f82c"
  head "https://github.com/zyedidia/micro.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "42b621909d3b7b61b41faf322f38f42e0739aa3964008a14686e5cba5e7bf9c3" => :sierra
    sha256 "d601ec47f7deaf7dd8421501feea65ea02bb631a67835cf12f9de7a230184027" => :el_capitan
    sha256 "a250e35d2688835bd858cda94ef5a55ae45ad0d9ba45c39456b04f85e067544c" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/zyedidia/micro"

    dir = buildpath/"src/github.com/zyedidia/micro"
    dir.install (buildpath/"cmd")
    dir.install (buildpath/"tools")
    dir.install (buildpath/"runtime")
    dir.install (buildpath/"Makefile")

    cd dir do
      system "make", "build"
      bin.install "micro"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
