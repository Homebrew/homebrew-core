class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.3.2.tar.gz"
  sha256 "ef8ce23df38d5076d25510baa2cabedffbe0af460d887d86c2413a1c2b0c676f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cc61b71352f218c2097897616816c87438636d4087a15060412711a5614b2342"
    sha256 cellar: :any,                 arm64_monterey: "8f48bfa9495ff1e3f5dbb3c84a849205ee4307cfca4ca0d4c9fdc5dd04304617"
    sha256                               arm64_big_sur:  "e2672691faeaba727acde6252c3dba8a39b9a0703f942f8f830d6e5514e15bb3"
    sha256 cellar: :any,                 ventura:        "8ac966da10799876d5b9e1065d2da6870cfd209c218977801e4d08ad5c7a7b2d"
    sha256 cellar: :any,                 monterey:       "4fa2dba2f40587cb7e1a3c837dae70c121509d858e44a5ec6bd564ba68c2cc3b"
    sha256                               big_sur:        "7561cdbc8327f77db0647112ae1496ca544c659a04dfe83e703c9edeee890869"
    sha256                               catalina:       "4d38d5dbea74b9eac4624877d7c7e29f08c38d68dedaaf9dadbdc5e3a820678b"
    sha256                               mojave:         "5796b96a6fc4781e134879993d0fa23816994c424d9984ec0584ae6b0bea2963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae437eeb42f5d9cde1bdafc1fc8fdcdca1dc940d638c4225f9303a9ae439a2fa"
  end

  depends_on "cmake" => :build
  depends_on "popt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    man1.install "doc/rdiff.1"
    man3.install "doc/librsync.3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdiff -V")
  end
end
