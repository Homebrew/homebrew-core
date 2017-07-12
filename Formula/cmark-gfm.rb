class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.27.1.gfm.4.tar.gz"
  version "0.27.1.gfm.4"
  sha256 "e1e55745b11183c96f2ece7a9ae2f1bd6b206869639af7516af8a4c646cd04d1"

  bottle do
    cellar :any
    sha256 "d993957074601725c7e3f62efb801c8c2dab5f6925367c0c55860d9b42f01a10" => :sierra
    sha256 "f9cc44d2cf15d95482c02ef8933a37ca38fbcb195b57a2767b93367eca93baad" => :el_capitan
    sha256 "a014aa99fd0bd996b7fa3a04ade6a87eb27aac675f7cd8ab95af31f00eb0e2f2" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  conflicts_with "cmark", :because => "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
