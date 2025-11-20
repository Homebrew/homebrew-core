class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "f0e42a25eca75468fe03afc5c0d029030db7d334d0b2d34ccaab2f8896a91a22"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e13614cf0562e9d98a0c143f68f0343620b9ac3c7689fbec35c5f6b0a3df2e1"
    sha256 cellar: :any,                 arm64_sequoia: "068015ae279edfc20777c8fbaa51f7da78f4d93ef7e8804f56cedabbe54b29ab"
    sha256 cellar: :any,                 arm64_sonoma:  "378e1cd0e89342fbe1b2c7aaa5db7c15a8576b5280464c87a687abd7a04133b0"
    sha256 cellar: :any,                 sonoma:        "45156f17c634db7f098a983319c1fb82d86971bda3f9f16666e5e9f526134bf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05ae42fa1269aeea29afc4ebaae03a0d415e3c287c8b84ef4f5a3c2ed223337f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e58b3d5fef40b48ef84f614c8c3d6b99d0368a8334734fc27f2356474b333d1f"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

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
