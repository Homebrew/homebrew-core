class Oak < Formula
  desc "Expressive, simple, dynamic programming language"
  homepage "https://oaklang.org/"
  url "https://github.com/thesephist/oak/archive/v0.2.tar.gz"
  sha256 "d06ba53f88490f5d8f70f45515afaf6ee8e4119c8ab477e3b4de8ef3cc7a2c05"
  license "MIT"
  head "https://github.com/thesephist/oak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "157869a20f19f4bd40dbd9e961258862a085e7e930cb8c72443d7ee1d50aa9e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2625e9701eed1dd3fac6a1ba7baf0f38bfdc1a2ac8d79f73c968a96df21bfd0c"
    sha256 cellar: :any_skip_relocation, monterey:       "bb6c1e672037f52957ff2d7b4e02e26323c3b40ad8e6420044aca45643fbd72f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f39aa243d1e2c43132c3ae641d960d83f19d0c5b9c755703ba34376c4d3feb9"
    sha256 cellar: :any_skip_relocation, catalina:       "719ceb4877cfd0a50b2df7cd1e0a8cfd877dee20a82dafe11554311a9422a4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66656295690dd8e69299937fa57ba9d183d69933257563234bad7ff5249a81e1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "Hello, World!\n14\n", shell_output("oak eval \"std.println('Hello, World!')\"")
  end
end
