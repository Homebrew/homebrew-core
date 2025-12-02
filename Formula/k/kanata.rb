class Kanata < Formula
  desc "Cross-platform software keyboard remapper for Linux, macOS and Windows"
  homepage "https://github.com/jtroo/kanata"
  url "https://github.com/jtroo/kanata/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "6c2d0bec8390cd0d7807aeb2550d0888434cd71d3e8c89a2765c18dd53b946ac"
  license "LGPL-3.0-only"
  head "https://github.com/jtroo/kanata.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a495b3b430c223e6748f4c50f99b078edb0a891ad04bc2d629c1e6c99b8a711d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0ef945f36a18a2234f509d9265814f6c55199b7e836cd9dbf0ad1886244da20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dc337b70fb78e29e208d23743cc85f5285bde45da6c5501965376a3aa7bc663"
    sha256 cellar: :any_skip_relocation, sonoma:        "abeb5cc6a3198a9c7aeb845a777d869e3c33f65074107017276765402cf33330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c07864e325d8ca5fe93260c0bf702ed748d578418443a2b477fd0efa0b44b72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4319ad42e1463a87c8e2599a26a6f3be145384da95ed078f1039963e3d3d9b3"
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
