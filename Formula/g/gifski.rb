class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.14.4.tar.gz"
  sha256 "7d6b1400833c31f6a24aac3a1b5d44c466e07f98af6d6c17487a7c8c6f4aa519"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "33386a67249fbbff0c640beee7acd1c9ffe3778d1cdd59c50e68e9c058faf477"
    sha256 cellar: :any,                 arm64_ventura:  "433365d8811a26048c1034616d1f6497674f095019b23ce4b7363937f1dfd3b7"
    sha256 cellar: :any,                 arm64_monterey: "5bd97a8e3795ec2f82cd0339d6011f4dd8b47fc26e3ad4dd3c1d156eaa0e061c"
    sha256 cellar: :any,                 sonoma:         "045ef48c53efdd0d2acbf3907b87fb29c94fbbc1ca58e14a566ce2529695e6d3"
    sha256 cellar: :any,                 ventura:        "c9da57fcca75648dcecef8f1c09d74d2a9c3a6a8f8afb181c977d41adf5d9b12"
    sha256 cellar: :any,                 monterey:       "82c0c350f48464e8af0fc0dba896372d59f92c6797af8634ba58f038484623ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01aae113b0bc2090e6c7d3004cc5f5afb1aaddb4917cf512a36abb34f297b8fb"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@6"

  uses_from_macos "llvm" => :build

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
