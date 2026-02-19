class Kanata < Formula
  desc "Cross-platform software keyboard remapper for Linux, macOS and Windows"
  homepage "https://github.com/jtroo/kanata"
  url "https://github.com/jtroo/kanata/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "42e71c76202ab1d39a4898851558deca277fc3619f11a7dcf0e376c5ffc287bb"
  license "LGPL-3.0-only"
  head "https://github.com/jtroo/kanata.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e33042a173476ca96bae7cbda19836a4efc074089ed3dbb558f929c3e20b15e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f46f564fb6abea62e5b58593ee3f38f9597c33934a284f900c2ea9eee45c1d1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "962193383f5f79208291702f4fc88921c85e19f513fae2198886b6604069d888"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f77ca47aa8567ebbd73a4b818cae0ae19d59fd343aae43bbc5b8dc0fef28d0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5620864dec3da6c090906d8582fc95e05fb06b6835f039f9843cf583db01af00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a453561372b89c594e1ca37945f577f39648e30098012c9fad3469a03e7eb07e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"kanata.kbd").write <<~LISP
      (defsrc
        caps grv         i
                    j    k    l
        lsft rsft
      )

      (deflayer default
        @cap @grv        _
                    _    _    _
        _    _
      )

      (deflayer arrows
        _    _           up
                    left down rght
        _    _
      )

      (defalias
        cap (tap-hold-press 200 200 caps lctl)
        grv (tap-hold-press 200 200 grv (layer-toggle arrows))
      )
    LISP

    system bin/"kanata", "--check"
  end
end
