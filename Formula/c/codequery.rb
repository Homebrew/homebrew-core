class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "5972a5778159835e37f5c9114a90f1be4756f27487d9074d2fb3464625a0ced2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "35482626a0cb4b75d6e6c917c77535b5cc49159703898930534c32374c778c27"
    sha256 cellar: :any,                 arm64_ventura:  "bb8601cb33c79b6fa462b4279138e60901a5bf4828441e6eb2c3ef0b7969bfcf"
    sha256 cellar: :any,                 arm64_monterey: "6dfb4a9564a48f8e371194fee1cc66850804dbe05304fac055f1238c4c16af32"
    sha256 cellar: :any,                 arm64_big_sur:  "8e61eb2e4bda1efe140f20516772ed6e192b6f932df86c3401c9de5e2f6dc39b"
    sha256 cellar: :any,                 sonoma:         "cd165f5d82bc7857b17078a5bf9edff9fce005fec83c21f642943afdcc807e9e"
    sha256 cellar: :any,                 ventura:        "b97d3a2af1846992e6594d2ad553c7c72ff218fed7fcc4c6a9457a36fb7538b5"
    sha256 cellar: :any,                 monterey:       "8f07b88f92a60578753b89cd5202a41e908faf36b4ac73d5ff73fa2aab628589"
    sha256 cellar: :any,                 big_sur:        "f2ddf6373596c5c563c4d0d120bb45b50c0a4f94865be50410f3a57b3b303338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c42a8a16ffec8983454e4f8c5485efb10f936781a1afdc683ed899c8deab558b"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = std_cmake_args

    share.install "test"
    mkdir "build" do
      system "cmake", "..", "-G", "Ninja", *args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    # Copy test files as `cqmakedb` gets confused if we just symlink them.
    test_files = (share/"test").children
    cp test_files, testpath

    system "#{bin}/cqmakedb", "-s", "./codequery.db",
                              "-c", "./cscope.out",
                              "-t", "./tags",
                              "-p"
    output = shell_output("#{bin}/cqsearch -s ./codequery.db -t info_platform")
    assert_match "info_platform", output
  end
end
