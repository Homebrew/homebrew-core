class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/6.3.0.tar.gz"
  sha256 "0c511910cd378a8bdf0c6de34123cbacaec74c18b5a4131093e940589a18946c"
  head "https://github.com/fletcher/MultiMarkdown-6.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f3b8a5112af603ca764cea0fbfc8d2a28857962b48e83933cc5c5675fc5f19c" => :high_sierra
    sha256 "8d9700ad126bd52e51da853503533b4d4d698561979b56af5f4ab0454bbc0187" => :sierra
    sha256 "1124f8f53c42310dd0876b87f23afb24962fbd462e71767103b7f7477ef9d590" => :el_capitan
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", :because => "both install `mmd` binaries"
  conflicts_with "markdown", :because => "both install `markdown` binaries"
  conflicts_with "discount", :because => "both install `markdown` binaries"

  def install
    system "make", "release"

    cd "build" do
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
