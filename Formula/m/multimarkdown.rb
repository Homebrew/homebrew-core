class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/refs/tags/6.8.0.tar.gz"
  sha256 "6568d1e5ccaffab3a8689909fe21f64066c13d5716a0010a4c3fffcb308d3f9e"
  license "MIT"
  head "https://github.com/fletcher/MultiMarkdown-6.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8464a52cbbc398b38438e3da65b17cd346fb766477904d686c6cf9314f6d6798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96c714c15dfd86fbaed058206c70a57d56cdb88aa50640a7a65d9f9b8929e563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b75dbe8648f77c5b61c2be840157c8b60df53f87b9f7a6070c322308629ce9c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e9d7f695bca48fe2dcd296f69e6f68b47194e98da433da42d21b48417c0a55c"
    sha256 cellar: :any,                 arm64_linux:   "a046aecc79a69c5554ba8d8fddeb1834e9c89187a112ae85a26e40bcb51b7297"
    sha256 cellar: :any,                 x86_64_linux:  "3ce18f8985e0e2ea7fe49270fbc02c6a7ad1766fecd77fbedfb3079c78f43f6c"
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", because: "both install `mmd` binaries"
  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "discount", because: "both install `markdown` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/multimarkdown"

    bin.install Dir["scripts/*"].reject { |f| f.end_with?(".bat") }
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"multimarkdown", "foo *bar*\n")
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"mmd", "foo *bar*\n")
  end
end
