class Libwapcaplet < Formula
  desc "String internment library"
  homepage "https://www.netsurf-browser.org/projects/libwapcaplet/"
  url "https://download.netsurf-browser.org/libs/releases/libwapcaplet-0.4.3-src.tar.gz"
  sha256 "9b2aa1dd6d6645f8e992b3697fdbd87f0c0e1da5721fa54ed29b484d13160c5c"
  license "MIT"
  head "git://git.netsurf-browser.org/libwapcaplet.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libwapcaplet[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0fe941d8b4a3a5f43b00e57bb2d338c53fff1fa2df2070e28cc5bc3bdb4cee97"
    sha256 cellar: :any,                 arm64_sequoia:  "c751d28cd839b73ae650342148ec11c12f0c74a02c74228e5a455012a9753dec"
    sha256 cellar: :any,                 arm64_sonoma:   "5610a67ece4b5be886260e784b100c438ec7c083c7043a4684aabf8bda19feac"
    sha256 cellar: :any,                 arm64_ventura:  "8323a6bff5ca487dd247baf5cf9e0176073b6c6ced4ded461c0d121606cf54d1"
    sha256 cellar: :any,                 arm64_monterey: "2d26edc578df10929cbe2fab48bebf5a21476a4eae3b8079ff20b840e181d8da"
    sha256 cellar: :any,                 sonoma:         "15ce272c1fdafa38065a3a567fde1c81430a414ee10646ab2b2da2ec91948575"
    sha256 cellar: :any,                 ventura:        "9ce24413c4c058e26f16e19cd7a4eb0e737f630959a093d388ca5596c4a7ccf0"
    sha256 cellar: :any,                 monterey:       "f5df809a0a5fab07b2722764d74d56540e045ce80b4ecba874318a17a395f534"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "805adde0d7a8af3bf673f484c91f30eec2625aa4164e9b7e1b84708623ac8041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d6d7288b404e81e20a7107f424e195d7faa5a8b8a68f5518bd8a8a0cdbdbd80"
  end

  depends_on "netsurf-buildsystem" => :build

  def install
    args = %W[
      NSSHARED=#{Formula["netsurf-buildsystem"].opt_pkgshare}
      PREFIX=#{prefix}
    ]

    system "make", "install", "COMPONENT_TYPE=lib-shared", *args
    system "make", "install", "COMPONENT_TYPE=lib-static", *args
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <libwapcaplet/libwapcaplet.h>

      int main() {
          lwc_error rc;

          lwc_string *str;
          rc = lwc_intern_string("Hello world!", 12, &str);
          if (rc != lwc_error_ok) return 1;

          printf("%.*s", (int) lwc_string_length(str), lwc_string_data(str));
          lwc_string_destroy(str);
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lwapcaplet", "-o", "test"
    assert_equal "Hello world!", shell_output(testpath/"test")
  end
end
