class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "https://fatsort.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.6.4.625.tar.xz"
  version "1.6.4"
  sha256 "9a6f89a0640bb782d82ff23a780c9f0aec3dfbe4682c0a8eda157e0810642ead"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/fatsort[._-]v?(\d+(?:\.\d+)+)\.\d+\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7d4a8f9701c12a1d3dd1acf54c007e7e554c139e13b1ec0038ef9c1203cb77e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b9d29782c670f94450fadca0c8f79027da00b123811f405b0d3b09075ab8d5c"
    sha256 cellar: :any_skip_relocation, monterey:       "422321e0d2f3d63e9d547a7e5b647cb6da4ba62f633c97aa065bfcbeb346a06c"
    sha256 cellar: :any_skip_relocation, big_sur:        "01b749fcfecc1b3a506b7f4e61562625861d693086803b1251491027be95e682"
    sha256 cellar: :any_skip_relocation, catalina:       "956dec116bc78d27db0553cf8f1bb9dcb499e22d7d162dfc1cd9ec13acc66412"
    sha256 cellar: :any_skip_relocation, mojave:         "8e3d9f4a4a63557db3aa3016a611bf96f4a1c46e15b305cbc803bce2036b28f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56f58efa4edaa7205e96e9267d2066dcb56e271c3e9140dd2edbaa63dc9ae617"
  end

  depends_on "help2man"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "src/fatsort"
    man1.install "man/fatsort.1"
  end

  test do
    system "#{bin}/fatsort", "--version"
  end
end
