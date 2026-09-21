class LttngUst < Formula
  desc "Linux Trace Toolkit Next Generation Userspace Tracer"
  homepage "https://lttng.org/"
  url "https://lttng.org/files/lttng-ust/lttng-ust-2.16.0.tar.bz2"
  sha256 "1e84e02fa1fc1261eb6cf3d14d64006506a29f7c605ac85de02180318c6aa38a"
  license all_of: ["LGPL-2.1-only", "MIT", "GPL-2.0-only", "BSD-3-Clause", "BSD-2-Clause", "GPL-3.0-or-later"]

  livecheck do
    url "https://lttng.org/download/"
    regex(/href=.*?lttng-ust[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "b9783f4c14aaf23eb6f138baadf288eefdb2887e08d52a301a45a2d915dfb927"
    sha256 cellar: :any, x86_64_linux: "3708d35a7f05a9b4071f7155bd2fa77ff0914987e2a7be9a8a4b1ddd5362c749"
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
