class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/6.2.3.tar.gz"
  sha256 "639c25ce0285f6e8ff119ef9c6416609a1f8ed0da7847e69245ec01d80262c4f"
  head "https://github.com/fletcher/MultiMarkdown-6.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35e966adf5a362b9c56968f716cfbffb85ae20aed2e9e42c9ad41b8677fdc841" => :high_sierra
    sha256 "d9569efcba9b2038fb8ddac568b464cdc724ceeffa7f35855a34d1a1535b0aca" => :sierra
    sha256 "c6087305b183bc7b29d8334b7e9df67be7078874f566c3748df79d10dbdd241f" => :el_capitan
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
