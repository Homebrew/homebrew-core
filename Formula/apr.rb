class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-1.7.2.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.2.tar.bz2"
  sha256 "75e77cc86776c030c0a5c408dfbd0bf2a0b75eed5351e52d5439fa1e5509a43e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "43d7a315b75512c306abc9d3c4b565f6055aaf74d4dd76ca5ef4982510a8dfe2"
    sha256 cellar: :any,                 arm64_monterey: "933669452ddcd56ad2de33b066886f5619701d24bdf25fb9851627a6f6383211"
    sha256 cellar: :any,                 arm64_big_sur:  "0de897019d6d6bb016d736ddb8abd030ced05199b12296191df368887cd15a52"
    sha256 cellar: :any,                 ventura:        "bd5e75c1eb97d724b1e3379882ea039648c07410e43d14b9b63f1114e9640054"
    sha256 cellar: :any,                 monterey:       "ad643047773efb61fea049f450e93ec8235681d7bb8e5038346d5412afe17232"
    sha256 cellar: :any,                 big_sur:        "5a31bfc312dbc46708437cceec41482dd73d14a65475f7b1317429365d1f509c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb12d8b8b2e4691cc2be81032892f11bd9a8e279cc183238d78a9893e3ab7bc5"
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

    # Install symlinks so that linkage doesn't break for reverse dependencies.
    # Remove at version/revision bump from version 1.7.0 revision 2.
    (libexec/"lib").install_symlink lib.glob(shared_library("*"))

    rm lib.glob("*.{la,exp}")

    # No need for this to point to the versioned path.
    inreplace bin/"apr-#{version.major}-config", prefix, opt_prefix

    # Avoid references to the Homebrew shims directory
    inreplace prefix/"build-#{version.major}/libtool", Superenv.shims_path, "/usr/bin" if OS.linux?
  end

  test do
    assert_match opt_prefix.to_s, shell_output("#{bin}/apr-#{version.major}-config --prefix")
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <apr-#{version.major}/apr_version.h>
      int main() {
        printf("%s", apr_version_string());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lapr-#{version.major}", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
