class Libcss < Formula
  desc "CSS parser and selection engine"
  homepage "https://www.netsurf-browser.org/projects/libcss/"
  url "https://download.netsurf-browser.org/libs/releases/libcss-0.9.2-src.tar.gz"
  sha256 "2df215bbec34d51d60c1a04b01b2df4d5d18f510f1f3a7af4b80cddb5671154e"
  license "MIT"
  head "git://git.netsurf-browser.org/libcss.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libcss[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9814ca0ac5b4222f4465ab3fd614f08d73fe9572e2c551cf456c636f71278b9"
    sha256 cellar: :any,                 arm64_sequoia: "f065539111cfaeb57ffaa1f1918d0a5eb40a27193a0de07a976d8822941bb5a0"
    sha256 cellar: :any,                 arm64_sonoma:  "c7083640028fdeeed54ea337f87d86686a92659392ed2939ed60947f06c95e43"
    sha256 cellar: :any,                 arm64_ventura: "50b100529a9304753171f567a8099c347d5f538d89b5fc0a673fa22c7a2ca347"
    sha256 cellar: :any,                 sonoma:        "69f0f19a1a2b2cd7e9493620542a5a2479035e2c2366889993091240366f21c5"
    sha256 cellar: :any,                 ventura:       "3b327a9d304d9964c5b98157661b194ba5156f4a32ca01af4e0ae835655aebbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c725d0e2a77a61777ee7704025ff633f09efd3011f99c456a855db6122744f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459691f366d4877a30ac535cf1767ed6f681a922435c3b7893d52eb6871c93a8"
  end

  depends_on "netsurf-buildsystem" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libparserutils"
  depends_on "libwapcaplet"

  def install
    args = %W[
      NSSHARED=#{Formula["netsurf-buildsystem"].opt_pkgshare}
      PREFIX=#{prefix}
    ]

    system "make", "install", "COMPONENT_TYPE=lib-shared", *args
  end

  test do
    (testpath/"test.css").write <<~CSS
      body {
        background-color: #FFFFFF;
      }
    CSS

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <libcss/libcss.h>

      int main() {
        css_error error;
        css_select_ctx *ctx;

        error = css_select_ctx_create(&ctx);
        if (error != CSS_OK) {
          return 1;
        }

        css_select_ctx_destroy(ctx);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libcss").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
