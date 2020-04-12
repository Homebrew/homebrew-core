class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/6.5.2.tar.gz"
  sha256 "97e9bb25e8eb151f178fd34212852f5d40d8fd01b317e718fded11603fafb773"
  head "https://github.com/fletcher/MultiMarkdown-6.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa4b46bc273d2afeb082a8a3d81cfdcebbdae947bca417962d2cb5cf0debc42f" => :catalina
    sha256 "aa4b46bc273d2afeb082a8a3d81cfdcebbdae947bca417962d2cb5cf0debc42f" => :mojave
    sha256 "1e2a03d1dc7bc2b14f7b051480c20f9692e67bfe05b3313f518fc27f344f858b" => :high_sierra
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", :because => "both install `mmd` binaries"
  conflicts_with "markdown", :because => "both install `markdown` binaries"
  conflicts_with "discount", :because => "both install `markdown` binaries"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "multimarkdown"
    end

    bin.install Dir["scripts/*"].reject { |f| f =~ /\.bat$/ }
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"multimarkdown", "foo *bar*\n")
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"mmd", "foo *bar*\n")
  end
end
