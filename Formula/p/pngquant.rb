class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://static.crates.io/crates/pngquant/pngquant-3.0.3.crate"
  sha256 "68a12bdd8825f9989f4ee9a6ab0b42727dae57728b939ef63453366697a07232"
  license :cannot_represent
  head "https://github.com/kornelski/pngquant.git", branch: "main"

  livecheck do
    url "https://crates.io/api/v1/crates/pngquant/versions"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json|
      json["versions"]&.map do |version|
        next if version["yanked"] == true
        next if (match = version["num"]&.match(regex)).blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3e16afa75e8c67f0bd33265a5b41bc386b3556c03f005665dfea57a8ce5be00"
    sha256 cellar: :any,                 arm64_ventura:  "8a1da7e0f02ac09b8d76e4d61303d68a00c06de630878d39a440652b441c087d"
    sha256 cellar: :any,                 arm64_monterey: "132f62c08f87aadc9243de4d6ac887050b61231ed175cabe9d753186be1b7151"
    sha256 cellar: :any,                 sonoma:         "6e973dbeded39f7b02bcf90cd3e6a271a8a4323cc35a0e0670a162b8037d9166"
    sha256 cellar: :any,                 ventura:        "c290edbea7b632f3cae66a0b9f1c5f67942d398290a2b439d2518d4a86a1b568"
    sha256 cellar: :any,                 monterey:       "c691267cf2d7a281d2bf23ddb745bfbba974cc0e8133e4b023e244d937c8ee41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5044118575aca60f3b593f1bce3a975976ba4bddf2b2f7105c1d6a7e8dd0514"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "tar", "--strip-components", "1", "-xzvf", "pngquant-#{version}.crate"
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
