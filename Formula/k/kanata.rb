class Kanata < Formula
  desc "Cross-platform software keyboard remapper for Linux, macOS and Windows"
  homepage "https://github.com/jtroo/kanata"
  url "https://github.com/jtroo/kanata/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "77ca650559fd9b5af283404c9582ffe89182ee9d4ff4154e7e2e483e68eeff8d"
  license "LGPL-3.0-only"
  head "https://github.com/jtroo/kanata.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df97ed1a656d62fcba8d9bdc9d5a8904c8dfbbd82b630723b296ce564868151f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0b74a5893bc0f6bff10502462dac37f9842b47f0bd77cb22cb8148dcefccd07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ca911a4ad48e270eb8d68f37f02bd447ddca389fcc8dc6138b795408abd3c9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0adac8827b4cf033a98aa81e6470a235ba54479e93f075db66ba3c4c0497747d"
    sha256 cellar: :any_skip_relocation, ventura:       "77ea8034460b27ba5eaa3589cf32af346699dab214334d801d90707fa612c96b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3a2eb12be9dbf1cb2e431f9ae84554863b6c136fbe48a593dfd1f6e42928201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "924dbdd95380eae94d5e732fa3f0686b1b07c4c34d60f8838b7caab820f706a2"
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
