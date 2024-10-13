class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/refs/tags/0.31.1.tar.gz"
  sha256 "3da93db5469c30588cfeb283d9d62edfc6ded9eb0edc10a4f5bbfb7d722ea802"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2ef6e622a90bf422b50d87ced249c01fcddf68577dca5c1d253ae49e65507612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ddac8c6456bff3ff163cb189b713cf3993cc2515d740e39b4f135d4233eb368"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19bbac821a80898d2fc9174479d3b0e6e8ec8e1fa104069714d504e8a859b4a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9520669d2fd57eb90ecda887a67c706bde219508516a1876ec73d4047acd0467"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc90c65f67d701afea02da66a2748b2cf5531a9ea490aca25ae05cab740b5550"
    sha256 cellar: :any_skip_relocation, ventura:        "574b08c9836e1c14a4956b5fdf387c97ba36d7956be1c59db8315586ec37de45"
    sha256 cellar: :any_skip_relocation, monterey:       "e94600f55338f8f6a328d24b917dfe4f2786f847f07bb178317aaf254c905bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44766462af04cc1d8e0ed724abd72297db90add455b432a395ba7c6caf175591"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  conflicts_with "cmark-gfm", because: "both install a `cmark.h` header"

  def install
    system "cmake", "-S", ".", "-B", "build",
                        "-DCMAKE_INSTALL_LIBDIR=lib",
                        *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = pipe_output(bin/"cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
