class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.0.tar.gz"
  sha256 "d49976b0b1e81146d79072f10cabe6634afcd318b1bd86b0102d5967121c43c1"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c1bedbb3305b3e492ac9b8f84ce653e7e9daa8efa21e82f96278f865849d4759"
    sha256 cellar: :any_skip_relocation, big_sur:       "c101f965a5430d204d3449f8389f42cc48cd1fdd751ff000aa353e044cf38030"
    sha256 cellar: :any_skip_relocation, catalina:      "c101f965a5430d204d3449f8389f42cc48cd1fdd751ff000aa353e044cf38030"
    sha256 cellar: :any_skip_relocation, mojave:        "c101f965a5430d204d3449f8389f42cc48cd1fdd751ff000aa353e044cf38030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f3e9521c6adb3a5135b9ce749b57720463bc94bc9c51f7f5428b101e801e4f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system "#{bin}/buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end
