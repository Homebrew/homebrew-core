class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "0fe9df689654735f1f4e1e6dd31aecbdb0e52f52784d082c9471a357144202e8"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5147b4f58bf5dd2f379559e569cf021a572b853568d1bf8d59416fe869754662"
    sha256 cellar: :any,                 arm64_sonoma:  "dc66ba33c71ca9ebf648f7382f44709f06620bedde3a55a614fca5296400bc8c"
    sha256 cellar: :any,                 arm64_ventura: "a7be91540787540353ef9fe9ce687d777141e1d6fb6bb2603872ee933b726481"
    sha256 cellar: :any,                 sonoma:        "71bc45af79edf3ef82ee1f98e781b9a4c578c35bdeaffdaa8c390a2f78a1fa96"
    sha256 cellar: :any,                 ventura:       "47ecf2b443bbe11730c2600ba0a5d3f3827b6d060887b3d30a859b3f48830578"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "093b5c6fd7b095a387d8469ac58b90773e8fea08fa568c610b85c9ed6f3f87ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "915a8368d4c5a083aafa5d8745d2515fd331aa540b9683ba1afff952946f5bdb"
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
