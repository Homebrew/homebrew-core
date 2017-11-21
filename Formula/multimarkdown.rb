class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/6.2.3.tar.gz"
  sha256 "639c25ce0285f6e8ff119ef9c6416609a1f8ed0da7847e69245ec01d80262c4f"
  head "https://github.com/fletcher/MultiMarkdown-6.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce412d4e0fac6e323ee1116286616e220e9b387cc22f3a0f1ccabb5e6da91257" => :high_sierra
    sha256 "ce412d4e0fac6e323ee1116286616e220e9b387cc22f3a0f1ccabb5e6da91257" => :sierra
    sha256 "25a7bbf52267afc1d94daca3a0ab560b035931663182eac8ae46ebfd2a6807bc" => :el_capitan
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
