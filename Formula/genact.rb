class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/0.7.0.tar.gz"
  sha256 "9bfb241d8d3e77dae63fa3f5c84ef67e459a03a8fc18ed4661e53765264288ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "1650cc3c9a42146f1e0ea30300d943c29a49a1e25680d80f4e20f2519c1bf00a" => :catalina
    sha256 "fd5ef1de4fea2b1c08785d77eacaf40936764bf843e627977b2ab348f1c190ef" => :mojave
    sha256 "efeb250335f9dc2ef86be2814243554933a99003a2f08aebf70339580917ff1d" => :high_sierra
    sha256 "adeebbec88a70c4e06eece55a38b71e4d7031d85add9cf4069744f4a8b4cd395" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match /Available modules:/, shell_output("#{bin}/genact --list-modules")
  end
end
