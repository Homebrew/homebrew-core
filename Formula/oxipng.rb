class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v3.0.0.tar.gz"
  sha256 "fd7584299375a630322b152878756297b0083492b7e4b9b17ae9978662e8c36a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "efec4545006c363b196773b0667a80a2894b020b8fe83e8fa63c3b2494193b25" => :catalina
    sha256 "3bdd648e50bad274f4616a7445d482752526df13f924623ba653031568b73c57" => :mojave
    sha256 "ed093c935c899acb8ae58b23611e383eb54e48b7fb645ad71b42344c6fd4275a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
