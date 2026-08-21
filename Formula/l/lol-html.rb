class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "76b29b987ede8ea8971edf4a07a0e2edf5a1dfe21a8d2c073f6534d01b2f5c9f"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ff453eb0f46dba632afa582e8ce611b790f85a4c4d28b65573735e6cb6fa6ba2"
    sha256 cellar: :any, arm64_sequoia: "ac1c72f921e0acec3c69177533e61a2228b2e7c984bfd19fac09ac88aa791594"
    sha256 cellar: :any, arm64_sonoma:  "b67aa6eb0266db37b7d9bd3ed21dc83134289c99b74d25819e8ea7f35ef6cff3"
    sha256 cellar: :any, sonoma:        "8510e92a4b70ccf1ef8c0cbe0edba138378e01ec6c646e32d6199b49caf90ab8"
    sha256 cellar: :any, arm64_linux:   "5f86df27a8b35afad2aebe25c7ef4b6248ec40523a7a4a2ee783b5ab356da532"
    sha256 cellar: :any, x86_64_linux:  "97ea3cf673dc69a9b570ab00f7e65caf4b8724f819241cad83284c9cc2b1c9e9"
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
