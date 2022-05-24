class LttngUst < Formula
  desc "Linux Trace Toolkit Next Generation Userspace Tracer"
  homepage "https://lttng.org/"
  url "https://lttng.org/files/lttng-ust/lttng-ust-2.13.2.tar.bz2"
  sha256 "08679a1dfc2c9428885273861628aa5d828972f389a38bb08fdce39adee589b7"
  license all_of: ["LGPL-2.1-only", "MIT", "GPL-2.0-only", "BSD-3-Clause", "BSD-2-Clause", "GPL-3.0-or-later"]

  livecheck do
    url "https://lttng.org/download/"
    regex(/href=.*?lttng-ust[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3c97fea89e34fbb3e032b29cf0dbf688212effbbc801e82cafdd527513725ad4"
  end

  depends_on "pkg-config" => :build
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
