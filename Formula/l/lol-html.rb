class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "41ed4231fd05b1c73c0664f1f05f18b0d96a34aabf488e6cb601c3bdc7306af9"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "996e618aec3e11c7545a6b17599769272e5713b50fa9b9b13630a6c11430122e"
    sha256 cellar: :any, arm64_sequoia: "0d077d68c9b36ef2d73477d554b5bde706978ad8b2e7426d184f61cdefe470e6"
    sha256 cellar: :any, arm64_sonoma:  "de61944da3bd3ac5f462ace058a1c6d688d862db275fb4b55d1330d10208177a"
    sha256 cellar: :any, sonoma:        "d4401724831f7ca8897e20f39707ce932d542e8980509eeea7aa83397d6102fc"
    sha256 cellar: :any, arm64_linux:   "2e5da20ecb2c9c47860af9f6c78000fd784ea9f0f9795484ef1d122eab536f31"
    sha256 cellar: :any, x86_64_linux:  "56f4047c7c7f34d1b184997bcb290dcd2d597434efca9023469fb0c3cff85d99"
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
