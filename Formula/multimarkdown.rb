class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/6.4.0.tar.gz"
  sha256 "fa9daa089bc0f8bc1f69fd7365778d59210b446ce7008d03b87fb572df8ff5d3"
  head "https://github.com/fletcher/MultiMarkdown-6.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebc7ddc3bd77a7bf46a94ab08ff99b5e40fe7022ab4a50abc67e3639827aa73b" => :catalina
    sha256 "67b5b3efbd5508240db39a8e07de73d3afb54b6d7026cfc91bd52c8bab84e4e8" => :mojave
    sha256 "4b0c84924e451362afe93a6046bfa31bb9ea567930f7d21ad2436241fc44d3d7" => :high_sierra
    sha256 "3a314a87893e7eea9fc3542d5574d5fdadf96a77763ddef403335a34ee21d35c" => :sierra
    sha256 "580595562320f4d5b78d0abb2e41f0773c91ef0c0bda6f7560486e3d05c52e13" => :el_capitan
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", :because => "both install `mmd` binaries"
  conflicts_with "markdown", :because => "both install `markdown` binaries"
  conflicts_with "discount", :because => "both install `markdown` binaries"

  def install
    # Reported upstream 2 Sep 2018 https://github.com/fletcher/MultiMarkdown-6/issues/142
    inreplace "CMakeLists.txt",
              "SET(CMAKE_OSX_DEPLOYMENT_TARGET \"10.4\"",
              "SET(CMAKE_OSX_DEPLOYMENT_TARGET \"#{MacOS.version}\""

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
