class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  # TODO: Remove `libexec` symlinks in `install` when we no longer have a Big Sur bottle.
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-1.7.5.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.5.tar.bz2"
  sha256 "cd0f5d52b9ab1704c72160c5ee3ed5d3d4ca2df4a7f8ab564e3cb352b67232f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "aa4997bb5769c8a7438cc204cc7b6a366ca96e32649855e1cc3a81fbe2b1f6c3"
    sha256 cellar: :any,                 arm64_sonoma:   "d4ddf068fd1c071ac911af823e5b7b6de2a4506a1812e95bc9505c844b5524fe"
    sha256 cellar: :any,                 arm64_ventura:  "bed002cafeb67dbf1cfe8a20691cdc8ca251ae3e7404caa9e839b92cf9cfe7b2"
    sha256 cellar: :any,                 arm64_monterey: "1272fcd1a362d19f3d57340ff356e9d3f6f332d8c28ca3f95dc184736d2b2d94"
    sha256 cellar: :any,                 sonoma:         "427b76fa372c2a89e40aeadbe559aabc39eabee537e785ac824309de2d53074d"
    sha256 cellar: :any,                 ventura:        "49cd82349f0bd06675d4eca2ccfa12c61f990e58063582faaca94ae93b4dc598"
    sha256 cellar: :any,                 monterey:       "ee20045b0546f5e70efa396f21e49c3354e2bbe5a6c7397f8cbe7638537aae2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dffbdbc595b875e62f84d705af046b4c95d4287fc61f2f0cc71e5480b6633a98"
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
    # Remove when we no longer have a Big Sur bottle.
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
