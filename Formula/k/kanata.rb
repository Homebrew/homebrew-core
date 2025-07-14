class Kanata < Formula
  desc "Cross-platform software keyboard remapper for Linux, macOS and Windows"
  homepage "https://github.com/jtroo/kanata"
  url "https://github.com/jtroo/kanata/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "754bed4c7317ae14c228288f3a24d23ab6c245e067f996336fc03b58f71c34b6"
  license "LGPL-3.0-only"
  head "https://github.com/jtroo/kanata.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97999cf53908cca6912d7da27f13b4188abc387f141bd0ef97753e98b674ea60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f7fb8e3dee7b7092d10dd60d960a2859c6d8736ea88d0a62d8ec270720e3427"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1375a69f5eb4e5edc83a659db28be8e011ec730fc9860de5b59ce94857ce8c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceb73a123a86d0b203e181d0aa62caf7742b4b226233ef1d43d60035986c7745"
    sha256 cellar: :any_skip_relocation, ventura:       "20b9a3dbf798435571371282744d38861c311a847d852fb63816c388e15b2dc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55f4248daf9266c373a6e6216081569359cb00e8cc666fc2f1cc2d086a428fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc1c026c6aac48ebf3a6a587d2e4b5f4b886ce192752e325a53084a201100720"
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
