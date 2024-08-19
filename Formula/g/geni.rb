class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "a27599bb9c6779d5be5269fabc68e232f6afc2c7f78f3dd6d2f342ff309421b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a9f032b71ef5da5dd3238f87f9ce65dedb76297f9f3497e814b6de390040054"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcc8e6092ab730359ff9b0d5dc843773b3d10a5be14a97b0d859399aa73a46e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1fa58b25a021db0ef9be2481e197fb19647f8514069a128b97e2287fb8c6fcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0f7ec200bce867ab1f840a8bf256ce9cd857d5012b77dfd1bd3c4a77265d89d"
    sha256 cellar: :any_skip_relocation, ventura:        "7ea2350dd2b26f0d1439ddcd8de00f802512e86a55ab8035405657619deba865"
    sha256 cellar: :any_skip_relocation, monterey:       "e8f3f659cf17ef00b25a1af917aa2a14c688d53a5e2afbd35bb6faacf9be46d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "428b5a0d93043a1607715c5828a724c98439f073077181e9c275ae2a278064fc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite"
    system bin/"geni", "create"
    assert_predicate testpath/"test.sqlite", :exist?, "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}/geni --version")
  end
end
