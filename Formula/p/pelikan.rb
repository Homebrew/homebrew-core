class Pelikan < Formula
  desc "Production-ready cache services"
  homepage "https://twitter.github.io/pelikan"
  url "https://github.com/twitter/pelikan/archive/refs/tags/0.1.2.tar.gz"
  sha256 "c105fdab8306f10c1dfa660b4e958ff6f381a5099eabcb15013ba42e4635f824"
  license "Apache-2.0"
  head "https://github.com/twitter/pelikan.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "64704f442e8c9c1bd917a94f37d152513fe8c4691ae6aecf24599bac242975cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cf1eea879a3b1eb8ec2d34616519f383cadea119d9dfec32ef89f93c5de3f248"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6074fdbebf10e608f76145fc4d41cf9be62d3b3ac67cf6b50ab1a1c21c0da76f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "395c03af1bab96be9a15937c4e3c997b8755a53abda5ab1f53227ebbc2cc6f7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a20c89a4c6828864b1b8d5361b97357795ef49ef517668237211c00a92bb0d80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22f695e695353e9317b34caf92789363464100d5ef63a7883a393767030e9951"
    sha256 cellar: :any_skip_relocation, sonoma:         "02443d1d5646a37dbb03e300e8121f75510312b2980e6b3a44e4839f8243424c"
    sha256 cellar: :any_skip_relocation, ventura:        "5252a921d70fa4834ab331666620c1296c8af4fe7bd90817b27dc39e21780e3f"
    sha256 cellar: :any_skip_relocation, monterey:       "52559baeef959550027d8d764a2a99d831d0b4a4d3041cb1e76a9c04b67c137d"
    sha256 cellar: :any_skip_relocation, big_sur:        "98b69e12d5ba1d3e8824e87f3fa5773a3bf7ba63dc2c32c73f07839b2c9d0e81"
    sha256 cellar: :any_skip_relocation, catalina:       "61441ad2aeeb6d14ab8fa6183944c1f4ab0733776e3f810ad17b80faf2f25faf"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f6fd25c2f404b5f43c23612cd1c87f1d5f87828da5110c903af3b3c58a66c7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "313be126d5718e0053ce871bbc09446325c24d3bce02117d940dcb45a922c99a"
  end

  depends_on "cmake" => :build

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `signals'; ../buffer/cc_buf.c.o:(.bss+0x20): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"pelikan_twemcache", "-c"
  end
end
