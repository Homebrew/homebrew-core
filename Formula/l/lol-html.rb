class LolHtml < Formula
  desc "Low output latency streaming HTML parser/rewriter with CSS selector-based API"
  homepage "https://github.com/cloudflare/lol-html"
  url "https://github.com/cloudflare/lol-html/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "47d806650801365ed872412da3d307ad6df1f40cd2e01a878c80251c6fd4484e"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/lol-html.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c8998aa0386eb740c4e78baa5e8f2897137cb03b9c836c8cee04c7092722f77"
    sha256 cellar: :any,                 arm64_sequoia: "3a4b95dd3b0df25d99d49b0ac3cf5b112800734ae186c3c1d29d30dbad0c942c"
    sha256 cellar: :any,                 arm64_sonoma:  "6b85bf4c8bdb3d5f59a1c986c2dc259a30cd2944316203b6966ef0a7382a5e72"
    sha256 cellar: :any,                 sonoma:        "c1a17e26e328ee914e0a1fd1004235e27fd66179aabb37fc28237bb2d00c8307"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc19bf38e02aa2228dd361f1f4ac78c42a4e34ef20b3a51667984c85d0ea3e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2bca0871c05e0228422f5f886548faf169674aee4a392444f1dd0ddbe062b2f"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

  # Backport c-api lockfile update, upstream pr ref, https://github.com/cloudflare/lol-html/pull/303
  patch do
    url "https://github.com/chenrui333/lol-html/commit/feefa33bbbab62af3a2e820fe76cdf3fbb532945.patch?full_index=1"
    sha256 "e02ec4dadc8a5db59edf430fbddc5973a2108a2a341586155a2c308b3919d5a4"
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
