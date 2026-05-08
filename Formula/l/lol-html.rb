class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "92ae8c20cdc30a09c596b331a59b6fc0f35f4e735d2f9e2e59cd66cd58083103"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cfa473b47043e5b2b9f79d0ef76a4bc564342f99909203a091e7182b3017f73"
    sha256 cellar: :any,                 arm64_sequoia: "da4120648589c454a6ac76a242cde093bb38d0318c7139d4848f2b8d3cb7ae12"
    sha256 cellar: :any,                 arm64_sonoma:  "378c0e3b8b3df82070dcc465fbaa5b7e26834895f50395fcd492911e03f88386"
    sha256 cellar: :any,                 sonoma:        "518c5176e97ab58006a6da50a8a8fe7565a292b5dd7dec6edf7787d026cffd00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0458e14c42e720c5fb1bea25746ce145e89358cabdb816c622d0e36c4c19118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a390425b7cc7005dd41a87c1eed2659d05038562d170629bdf1b0473b4d74513"
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
