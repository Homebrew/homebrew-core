class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/6.3.2.tar.gz"
  sha256 "2b02c2b42a216128ee1596c93840c6e097155aa1c854578535dcf4a0c09b2ff9"
  head "https://github.com/fletcher/MultiMarkdown-6.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b1f221bb7b67fd1f41461062abceb6367b80bdc8eebc9aeebda0329d34941f5" => :high_sierra
    sha256 "2338a2018abbe28d753e8c4c293b1002259c480a24f8ccea26660b846d7358ba" => :sierra
    sha256 "aa2f1ca29b6bb27482329344ead21e774b8a73785e1a9173ae3ccbf70e200b8d" => :el_capitan
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
