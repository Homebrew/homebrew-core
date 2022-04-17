class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/8.1.1.tar.gz"
  sha256 "817497a17bf131afb1ea4fa53eaeeca566949360be168b393260a18ea64c0dbb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d61adf0258b6080b1b4b9467ea710443b43c1e69ca5c1ec6bfcd8c1c24a76ccf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "910eb2587177abddce175a15304ee7b926b9d2521dd2f2f029815dc670a39503"
    sha256 cellar: :any_skip_relocation, monterey:       "528c6890130e504d9be589e87bf672ebfe633e425cff52d2d6265bde48d8d0d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f52d7e751568ca0ccc941084867965db707dd43e754e9d2e3d043f09774c9c9"
    sha256 cellar: :any_skip_relocation, catalina:       "f2f263e86cd4cc62d742b900ed69864cd402deb16cfbd84b89ce5dd72473c682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f539748cefa9554314d6764e007584f9d371504b1afc97752c67c591d4633c34"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
