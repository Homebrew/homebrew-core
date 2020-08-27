class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v0.10.0.tar.gz"
  sha256 "c8db67ba56e7c327540cb5a883abcb0ab682378e9dacef79056502f32ad3c759"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "814b886307623c9a1eded2f6e774f06d6827dd491b23dc3cc3dd1e839adb48be" => :catalina
    sha256 "867c8a47b87062e03a14b0e88503333a73050be8b1ef7db41ff0eed124a1d03c" => :mojave
    sha256 "194eda0bcb43dcbad2214c1f0736c53c7bf5a7e2281ec025c019aae0f9accae9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match /Available modules:/, shell_output("#{bin}/genact --list-modules")
  end
end
