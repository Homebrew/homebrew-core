class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "http://fletcherpenney.net/multimarkdown/"
  # Use git tag instead of the tarball to get submodules
  url "https://github.com/fletcher/MultiMarkdown-5.git",
    :tag => "5.3.0",
    :revision => "b03f660e73abc6d5243b829a0cbe4899c86dc435"

  head "https://github.com/fletcher/MultiMarkdown-5.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c6c18b293bc6df5495af9e6048b114d9582b14c99edfc790f1edb01341c665f" => :el_capitan
    sha256 "5ca4d414003d869395880dcf4068b15421464ce6aabd32711b21d31bab49750c" => :yosemite
    sha256 "070759d16a75575f519ee4f8dd263940df46cff83a901a925ebd4da1c4f7871b" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", :because => "both install `mmd` binaries"
  conflicts_with "markdown", :because => "both install `markdown` binaries"
  conflicts_with "discount", :because => "both install `markdown` binaries"

  def install
    system "sh", "link_git_modules"
    system "sh", "update_git_modules"
    system "make"

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
