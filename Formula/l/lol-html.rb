class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "36c16a67d844f0bdd9a64edfe66e9434e0cdd122495abdecdc0cb396ce496657"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ac23fcab20e7497687b030da0d67834d181d6555472aa6af4d06a2873c41b3a"
    sha256 cellar: :any,                 arm64_sequoia: "88fb3586a8cd7ac1ed7313c288286d9eb9e506b04a47b6e664b6364c2e6179d1"
    sha256 cellar: :any,                 arm64_sonoma:  "04a9f66608ec7474c729b01b237eae1d8b4d373a47cdef0b62a88c92eefde3dc"
    sha256 cellar: :any,                 sonoma:        "1dc00e1e14ea1359ee8878801e4e8f49c07b2c5ce58236ed4e45d8fb986f1139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd93431ac2581d0399677d8740fe19d501c609b6443fdb7116124eba439c4519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8830b38ac6348996aacf12c68052653cbdfc28e2b5c7bd4fd85a82b86cd655ac"
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
