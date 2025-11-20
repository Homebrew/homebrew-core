class Ctail < Formula
  desc "Tool for operating tail across large clusters of machines"
  homepage "https://github.com/pquerna/ctail"
  url "https://github.com/pquerna/ctail/archive/refs/tags/ctail-0.1.0.tar.gz"
  sha256 "864efb235a5d076167277c9f7812ad5678b477ff9a2e927549ffc19ed95fa911"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "90852c66651a883f061c0c6d2b2c1281e6b8e1cad687fd14e94a056f4fb62554"
    sha256 cellar: :any,                 arm64_sequoia:  "21800dfc7f1557473cc6fe1b4e0716d4fb100c86acbd6bbfe3751b36b02a37f6"
    sha256 cellar: :any,                 arm64_sonoma:   "4022c3a7de59341455b5be26f2ff72dfc10c4488b0268e18d30057bee351fc3e"
    sha256 cellar: :any,                 arm64_ventura:  "2b40393969bdf9a4676ee936099af2cfbe92c006e87ce6c62b44761d24328b10"
    sha256 cellar: :any,                 arm64_monterey: "0b339ed01671f93d78b97a473d2ab4710182097276def040447573b274003e59"
    sha256 cellar: :any,                 arm64_big_sur:  "d4f6bf36550a739d7ad22a28200fe2cfb4fc18798fb2af832f380a1b2411803a"
    sha256 cellar: :any,                 sonoma:         "9b6bcfa6fb51cc9b44d58409377b3042acd54ad8eef8d60e69639699eb3e9ba9"
    sha256 cellar: :any,                 ventura:        "c168ea95ba0e8639c4f1152c19a8cbb831ac1cd7f108c2fc9ac37eab03e0ed23"
    sha256 cellar: :any,                 monterey:       "be4aa07bfd921f4903112f0ff6dbccc979b86cae77cdd75fe4ae9e2bcb3ff101"
    sha256 cellar: :any,                 big_sur:        "31c851cee6019ade6def5da7a50b2d901d04e1038d9d01d6985ac57a700a810f"
    sha256 cellar: :any,                 catalina:       "0821eb3a9bf969519149b7cb3038db2dc25836bc335c057e0ff263aa5fc2f7b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f4eddd733efe18c74eadb393d0ab41d51a5b4972857c6022a39c955595e2ab2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "583c009e46c529593648a48442ba5544aa1ac7ebb3cf1309c2e1eb08ed9f9439"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "apr"
  depends_on "apr-util"

  conflicts_with "byobu", because: "both install `ctail` binaries"

  def install
    # Workaround for ancient config files not recognizing aarch64 macos.
    system "autoreconf", "--force", "--install", "--verbose" if Hardware::CPU.arm?

    system "./configure", *std_configure_args,
                          "--with-apr=#{Formula["apr"].opt_bin}",
                          "--with-apr-util=#{Formula["apr-util"].opt_bin}"
    system "make", "LIBTOOL=glibtool --tag=CC"
    system "make", "install"
  end

  test do
    system bin/"ctail", "-h"
  end
end
