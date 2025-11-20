class LttngUst < Formula
  desc "Linux Trace Toolkit Next Generation Userspace Tracer"
  homepage "https://lttng.org/"
  url "https://lttng.org/files/lttng-ust/lttng-ust-2.14.0.tar.bz2"
  sha256 "82cdfd304bbb2b2b7d17cc951a6756b37a9f73868ec0ba7db448a0d5ca51b763"
  license all_of: ["LGPL-2.1-only", "MIT", "GPL-2.0-only", "BSD-3-Clause", "BSD-2-Clause", "GPL-3.0-or-later"]

  livecheck do
    url "https://lttng.org/download/"
    regex(/href=.*?lttng-ust[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "5da4073ec0623f415145ab5a8507a7243c2ea3781461598c43a099c4ff65bc53"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c24d5740d8025b7b2b7e330d7a1c3477f0243126ad447abaefdde0a032deccf6"
  end

  depends_on "pkgconf" => :build
  depends_on :linux
  depends_on "numactl"
  depends_on "userspace-rcu"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    cp_r (share/"doc/lttng-ust/examples/demo").children, testpath
    system "make"
    system "./demo"
  end
end
