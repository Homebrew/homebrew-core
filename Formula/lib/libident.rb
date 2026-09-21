class Libident < Formula
  desc "Ident protocol library"
  homepage "https://www.remlab.net/libident/"
  url "https://www.remlab.net/files/libident/libident-0.32.tar.gz"
  sha256 "8cc8fb69f1c888be7cffde7f4caeb3dc6cd0abbc475337683a720aa7638a174b"
  license :public_domain

  livecheck do
    url "https://www.remlab.net/files/libident/"
    regex(/href=.*?libident[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "6b861ec0af132f3c2d86d08ddae33e192040da20d28a518f5158d4742705bdd3"
    sha256 cellar: :any, arm64_tahoe:       "5bf318f1e22090881f6f7ee6f7d27bea66e0738da64488e8a2c23b358b00fe05"
    sha256 cellar: :any, arm64_sequoia:     "ebf7a988b65d7a6c90e56d121775a417a245e07d7332a6425725044b87182994"
    sha256 cellar: :any, arm64_linux:       "7b8b5f724c158bb5c33c807ae42da3f5c23175492a8eb76d4ba2fca2d2a588c6"
    sha256 cellar: :any, x86_64_linux:      "99c32352a9e686bb57eec6f756c68cce76e4fa727a67309dc3c64b4d70cd1642"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Run autoreconf to regenerate the configure script and update outdated macros.
    # This ensures that the build system is properly configured on both macOS
    # (avoiding issues like flat namespace conflicts) and Linux (where outdated
    # config scripts may fail to detect the correct build type).
    system "autoreconf", "--force", "--install", "--verbose"

    # C23 makes `()` mean `(void)`, breaking the K&R-style signal handler pointer in id_query.c
    ENV.append_to_cflags "-std=gnu17"

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end
end
