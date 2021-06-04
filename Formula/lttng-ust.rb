class LttngUst < Formula
  desc "Linux Trace Toolkit Next Generation Userspace Tracer"
  homepage "https://lttng.org/"
  url "https://lttng.org/files/lttng-ust/lttng-ust-2.12.2.tar.bz2"
  sha256 "bcd0f064b6ca88c72d84e760eac3472ae5c828411c634435922bee9fce359fc7"
  license all_of: ["LGPL-2.1-only", "MIT", "GPL-2.0-only", "BSD-3-Clause", "BSD-2-Clause", "GPL-3.0-or-later"]

  depends_on :linux
  depends_on "numactl"
  depends_on "userspace-rcu"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    cp_r (share/"doc/lttng-ust/examples/demo").children, testpath
    system "make"
    system "./demo"
  end
end
