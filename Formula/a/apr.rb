class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-1.7.6.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.6.tar.bz2"
  sha256 "49030d92d2575da735791b496dc322f3ce5cff9494779ba8cc28c7f46c5deb32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8dbcf3f996ba1148b936081612ff5228cb4ba5a08de6635a695bd9ec6963266"
    sha256 cellar: :any,                 arm64_sequoia: "58a68eee9f289319c41100b42bddbaa265366c093e0c0f83e4295c7a535d7395"
    sha256 cellar: :any,                 arm64_sonoma:  "d89324cbc51a250e109e00dc2e90ce77611058027060c39c83bb771118502332"
    sha256 cellar: :any,                 arm64_ventura: "c9c536ea3504e24b30b5cf6187100f746eba704e237d3839d0c04feb98df623e"
    sha256 cellar: :any,                 sonoma:        "fdf0f628598225db7ea43128abaf944011df61e2469811709c250607745b8570"
    sha256 cellar: :any,                 ventura:       "327273dae10ae18781b2f347531253d968e0c06533c913a80d775a5972e65477"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee70c4b7041ea9743a1f87c8c0c9dc14e7a3372ab5d5e073912913b83cf2bcc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a52537b5ff653a7c477dd67be99faeb1684d3002cd9afe6c24501118083a6154"
  end

  keg_only :provided_by_macos, "Apple's CLT provides apr"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "util-linux"
  end

  def install
    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    system "./configure", *std_configure_args
    system "make", "install"

    rm lib.glob("*.{la,exp}")

    # No need for this to point to the versioned path.
    inreplace bin/"apr-#{version.major}-config", prefix, opt_prefix

    # Avoid references to the Homebrew shims directory
    inreplace prefix/"build-#{version.major}/libtool", Superenv.shims_path, "/usr/bin" if OS.linux?
  end

  test do
    assert_match opt_prefix.to_s, shell_output("#{bin}/apr-#{version.major}-config --prefix")
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <apr-#{version.major}/apr_version.h>
      int main() {
        printf("%s", apr_version_string());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lapr-#{version.major}", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
