class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/6.5.2.tar.gz"
  sha256 "97e9bb25e8eb151f178fd34212852f5d40d8fd01b317e718fded11603fafb773"
  license "MIT"
  head "https://github.com/fletcher/MultiMarkdown-6.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fda293b3a57480609f06eee55ec2ba8d65799577df2be38c0af1cc70e22fcd9d" => :catalina
    sha256 "ce5d41628cd36556b2e6375a88dce78d90da7502033fe147fff90c3d542bd7c9" => :mojave
    sha256 "fde9097e38d1fdb2161d71eb81758e25c1a1a39120a27c931e2d408ac8338fd6" => :high_sierra
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", because: "both install `mmd` binaries"
  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "discount", because: "both install `markdown` binaries"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "multimarkdown"
    end

    bin.install Dir["scripts/*"].reject { |f| f.end_with?(".bat") }
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"multimarkdown", "foo *bar*\n")
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"mmd", "foo *bar*\n")
  end
end
