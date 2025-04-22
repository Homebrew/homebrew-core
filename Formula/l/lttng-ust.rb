class LttngUst < Formula
  desc "Linux Trace Toolkit Next Generation Userspace Tracer"
  homepage "https://lttng.org/"
  url "https://lttng.org/files/lttng-ust/lttng-ust-2.13.9.tar.bz2"
  sha256 "2ad6d69a54a1d924c18a4aa7a233db104e3cc332bcdd240e196bf7adbed3f712"
  license all_of: ["LGPL-2.1-only", "MIT", "GPL-2.0-only", "BSD-3-Clause", "BSD-2-Clause", "GPL-3.0-or-later"]

  livecheck do
    url "https://lttng.org/download/"
    regex(/href=.*?lttng-ust[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "82999691af90f0e37ed955ac223e6d13eb1122cddf8ca193800073ead4e20872"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "40ac3ae63f09a24a74a2a4a944cb18d3fcc546b5fb805501fdded29449b9efcb"
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
