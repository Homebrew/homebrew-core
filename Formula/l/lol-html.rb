class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "94a67aaa601b456fe8cf765456571854850162498da2cd0efcfeed2a3149aa9a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a5bf511b0e79fafebf68e51d8d70ce2849b7cac56441234176b45b0d4283984"
    sha256 cellar: :any,                 arm64_sonoma:  "b1071b1948acd68a50e8cb9f119533de8417bbc5ec0faa1c53fdd47e83ffe93e"
    sha256 cellar: :any,                 arm64_ventura: "adca8690479cc493a5d8faccec5325382dceddef1700cfe0d1c2063d093ac280"
    sha256 cellar: :any,                 sonoma:        "441869e3e8e1c9807844c36e7cd0e21d25d2f4c753374554c6835bbc9d6448fd"
    sha256 cellar: :any,                 ventura:       "5b06c440efeee13f08a8560fc990c1c2ee960f75e77537e4ea471f478615f70f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c2095241f8b34ccc99cb2db8fa903a96348508638aadb468b4f89a79e9408d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17393e6b70e0c070a3b363e44466bb4fa6f767936604c601c5aaae4a58381f87"
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
