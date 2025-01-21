class Kanata < Formula
  desc "Cross-platform software keyboard remapper for Linux, macOS and Windows"
  homepage "https://github.com/jtroo/kanata"
  url "https://github.com/jtroo/kanata/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "eb7e11511f77558d72b5b3b0c9defb04b269637e5c8a4ad9b45d21382e9247d2"
  license "LGPL-3.0-only"
  head "https://github.com/jtroo/kanata.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4f7a14dcaf0958380d869568c7e2080f81fa3f04596fb0401185ccfdd2e8b79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd7cf9e89759f062308e6959b1e886c7ba3f538283e00e3b825418191a4146c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a66f9003045cb35e1007c11dc43b999ad4fab326329cde8bc7c38339c715ea86"
    sha256 cellar: :any_skip_relocation, sonoma:        "80c18dc21e71b7b4d9d3751cb2863b4a9676a38cfd41afd554de7106417c713a"
    sha256 cellar: :any_skip_relocation, ventura:       "6d3b50c939ef8a45a0b2a9a49ebd805f3d59ec4ac5028fca549e8e254db7f405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68c745a366776fd771c26f076ed63e31618d9b09556f977700e32b7e12ce2ee"
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
