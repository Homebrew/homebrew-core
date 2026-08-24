class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.0.6.tar.gz"
  sha256 "8e43c1579001d8f97695bb50f2486a3ce48442797fb56d80519335312af34fbd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7c16a33bf355e0a17f1d07f435b82fbfca9d8a582cd4d1d238b96fb3bc687ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c01c81c8d7fb0a62ec6ab981ff18c9ab5093665ebc1c7a594832f5cefe520d02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b142db010e5d7bfb39b780d2219b53f722de003a118d225d2995acef99b4f906"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec5b26f07dae2d7537e2ff753ab8a13485f8da9a00042fc9eb345084d6944a26"
    sha256 cellar: :any,                 arm64_linux:   "5cdb79a7b77a5087beca221e0a27f1405639baf585ee0d04bf531b07bb169748"
    sha256 cellar: :any,                 x86_64_linux:  "b03714ca37effcd98af8ca40a2603da14f75aaedd4a444933cd0bf0d219dc2ed"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end
