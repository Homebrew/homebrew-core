class Pngcheck < Formula
  desc "Print info and check PNG, JNG, and MNG files"
  homepage "https://github.com/pnggroup/pngcheck"
  url "https://github.com/pnggroup/pngcheck/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "a24ac2348efca5895e9d6f53fd316f3d5c409ab92a74b2b8106541759304da53"
  license "HPND"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5129a5a31646dd3d0682d52b49ecde46e9bfe99cf95c968efb1c0e817c0b293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38bc6c12e076844ca6ecdfb73f688059894c59aabc2ba9b71ed91d7c8e6efd99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa7075580867ff1a3472181c6acb62ec389d9b3082af624fa0d7b5cf33bf044b"
    sha256 cellar: :any_skip_relocation, sonoma:        "504007718b874754d4e61a385fc91f4c3eddbf2fbba5bda008096f1ab0336e8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c027bcf0f0460c856c30045bd0817889efd8da5270f935e4185a8e9bbef008d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfffc05c485bdea62324b3f9813b124d42ff59be09dc52ab6c7e43137d9f9ffa"
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  def install
    # Remove files only needed on non-Unix. Doesn't need to be removed as CMake handles it
    # but they have different or dubious licenses so let's be explicit to prove that the above license DSL is correct.
    rm_r "amiga"
    rm_r "third_party"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"pngcheck", test_fixtures("test.png")
  end
end
