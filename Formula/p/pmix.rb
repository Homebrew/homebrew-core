class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.github.io/"
  url "https://github.com/openpmix/openpmix/releases/download/v5.0.3/pmix-5.0.3.tar.bz2"
  sha256 "3f779434ed59fc3d63e4f77f170605ac3a80cd40b1f324112214b0efbdc34f13"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "33cec8bbbc0471911bb5a771e4e06dbbbc8c0bd891d4fb8dca8fa8783966fdcf"
    sha256 arm64_sonoma:   "1bb946832094eaf4ecd78549b1181a43951eb0c2ebf4c23af834263f3a39ff07"
    sha256 arm64_ventura:  "b82da6ad74dcc27768c9d113e0999eade722e537ca917bfc6861bc68cc301c6e"
    sha256 arm64_monterey: "5dd890f4c203eb25ed381d774e9a2f545ceffe931d8079a5a6b0315ac23123a0"
    sha256 sonoma:         "22ea4e40253d3f2cf622ae00a807ac7b51a4a88e88ed733b91a3b8bda7634de3"
    sha256 ventura:        "1a86b55384410e3e6c5ff8475c2a914edf129353703b3f57bb688585671a99e1"
    sha256 monterey:       "0a674c9dd2072fe0ffdef3d8ae69eaa82bd7b06df49924080d8ed41f41cae5a8"
    sha256 x86_64_linux:   "25efde60eb0f20026a88f62786eccb14b14260449fa5405922a3160cc83d3d96"
  end

  head do
    url "https://github.com/openpmix/openpmix.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "hwloc"
  depends_on "libevent"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    # Avoid references to the Homebrew shims directory
    cc = OS.linux? ? "gcc" : ENV.cc
    inreplace "src/tools/pmix_info/support.c", "PMIX_CC_ABSOLUTE", "\"#{cc}\""

    args = %W[
      --disable-silent-rules
      --enable-ipv6
      --sysconfdir=#{etc}
      --with-hwloc=#{Formula["hwloc"].opt_prefix}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-sge
    ]

    system "./autogen.pl", "--force" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <pmix.h>

      int main(int argc, char **argv) {
        pmix_value_t *val;
        pmix_proc_t myproc;
        pmix_status_t rc;

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpmix", "-o", "test"
    system "./test"

    assert_match "PMIX: #{version}", shell_output("#{bin}/pmix_info --pretty-print")
  end
end
