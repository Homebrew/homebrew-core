class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "b36ad8ccafce9da350f4d9c32bb31bf46dddae0798d4ad6213cabd7e166e159e"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4cadd58a4d682208b314cc60b00179588b8f97108232ef9ff53fa70af6155d8"
    sha256 cellar: :any,                 arm64_sonoma:  "91d1f354c3cc9be65d141f16fbb1af71ebbbd8faf83160522665289b3c25d6dd"
    sha256 cellar: :any,                 arm64_ventura: "1cfa2ca138b7cbae4d243b2614035731dec1957d4240d59bdb94c5c3f57d01e9"
    sha256 cellar: :any,                 sonoma:        "f98f2ef369748568691b5c543947a28a9578f49622df800ed41a3fc74329f0b6"
    sha256 cellar: :any,                 ventura:       "a3a0fecd1225ec17fd595d6837a6068c4fa67a4b994a1cd2c8649b90682d73e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51e1689d13719659a73ab392aa50c4aed0cc1e9a53ac4cc58d02f04355917f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39fbe4d09f2a5713cd82bccfb637cb7178edb9b34ce23b31a53c783c98631f8e"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

  # update cargo.lock, upstream pr ref, https://github.com/cloudflare/lol-html/pull/266
  patch :DATA

  def install
    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--locked",
                    "--manifest-path", "c-api/Cargo.toml",
                    "--prefix", prefix, "--libdir", lib
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <lol_html.h>

      int main() {
        lol_html_str_t err = lol_html_take_last_error();
        if (err.data == NULL && err.len == 0) {
          return 0;
        }

        return 1;
      }
    C

    flags = shell_output("pkgconf --cflags --libs lol-html").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/c-api/Cargo.lock b/c-api/Cargo.lock
index 954418c..14d2c9c 100644
--- a/c-api/Cargo.lock
+++ b/c-api/Cargo.lock
@@ -176,7 +176,7 @@ checksum = "a7a70ba024b9dc04c27ea2f0c0548feb474ec5c54bba33a7f72f873a39d07b24"
 
 [[package]]
 name = "lol_html"
-version = "2.2.0"
+version = "2.3.0"
 dependencies = [
  "bitflags 2.6.0",
  "cfg-if",
@@ -191,7 +191,7 @@ dependencies = [
 
 [[package]]
 name = "lol_html_c_api"
-version = "1.1.2"
+version = "1.3.0"
 dependencies = [
  "encoding_rs",
  "libc",
