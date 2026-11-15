class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "8f48db734cdbd2edbb2de08038244b4c4a9620ae2f0726f8a6f7ed05e965d220"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1274b031831516cb2449c3b99ced569a2a13a0ffcb2fea074c940e57de84893f"
    sha256 cellar: :any, arm64_tahoe:       "2372fb715647e9a2d9a92f30bcd7487880a1f00ea7be666e047e2e252a19e719"
    sha256 cellar: :any, arm64_sequoia:     "bea2758cf3b7d321cef668b7ff6f5a1ad38a2b3008975a269e86638e4d0f35ec"
    sha256 cellar: :any, arm64_linux:       "783ec253d0e3bf4fcfb312c6dd6aff8e769ac8d860fbc46a2627e63f50dbdd99"
    sha256 cellar: :any, x86_64_linux:      "5f2d55b29c8950c8390eadaade90c38bafea336e9314684728f6c4e10b95306d"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

  deny_network_access!

  def fetch
    cd "c-api" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

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
