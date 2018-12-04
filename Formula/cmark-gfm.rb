class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.28.3.gfm.19.tar.gz"
  version "0.28.3.gfm.19"
  sha256 "d2c8cb255e227d07533a32cfd4a052e189f697e2a9681d8b17d15654259e2e4b"

  bottle do
    cellar :any
    sha256 "9dc3b3299af2f9b6c296b5274072a4fc4bdb4e03ef128b15c67b8a4d8276b87f" => :mojave
    sha256 "c9c688f80020c67d59047cb9b1d8d1b668c8ebc615d9c1ac3043b3afc4a26420" => :high_sierra
    sha256 "d809dd43688fdaa9abc423540bf0702a00304a4de01a7e0af90ea682aefd2ab5" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

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
