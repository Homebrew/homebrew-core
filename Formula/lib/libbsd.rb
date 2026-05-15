class Libbsd < Formula
  desc "Utility functions from BSD systems"
  homepage "https://libbsd.freedesktop.org/"
  url "https://libbsd.freedesktop.org/releases/libbsd-0.12.2.tar.xz"
  sha256 "b88cc9163d0c652aaf39a99991d974ddba1c3a9711db8f1b5838af2a14731014"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause",
    "Beerware",
    "ISC",
    "libutil-David-Nugent",
    "MIT",
    :public_domain,
  ]

  livecheck do
    url "https://libbsd.freedesktop.org/releases/"
    regex(/href=.*?libbsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "c7f96d1094ff2cc9da0513b16d0b0367baf7181648c7b95c18e038283cd76e0d"
    sha256 cellar: :any,                 arm64_sequoia: "efbaa69a0a35faffb4aea0d753dfb2b9c0d69d2b75e082da79ff3c1217f71220"
    sha256 cellar: :any,                 arm64_sonoma:  "f83011f7c421cbb84332def855f6ec9ed8e7983f33ca6094086f3e014620ff29"
    sha256 cellar: :any,                 sonoma:        "75da4f4a420c5f2bf1d05a57bd1709768b135c2a9d7b464e788ee07360e58546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fc7e073b4e59abb66635d251ee2b38613647c439adaae8ab3e3a414cfc55107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d82953bbd9f2e841648eb4a768da6d598d2b023d1976056e67245295dc84adf9"
  end

  head do
    url "https://gitlab.freedesktop.org/libbsd/libbsd.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "libmd"
  end

  def install
    system "./autogen" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <bsd/stdlib.h>

      int main(void) {
        const char *q;
        long long val = strtonum("1", 0, 10, &q);
        if (q != NULL) {
          printf("%s", q);
          return 1;
        }
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", lib/shared_library("libbsd", version.major.to_s)
    system "./test"
  end
end
