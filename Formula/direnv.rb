class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.22.1.tar.gz"
  sha256 "b902f30deadd332b8553ca0f34aacf6daf62bd104b5d57ecc9bee2fdcd70d1c7"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "073d42ded5dbe7bb69c70b460bbb1b680bbc21ba2452be480fb68166a69317de" => :catalina
    sha256 "ebd09d4943561e66c1c4a9261c47fb965b10c058391fe8897888d2adb8f68ec2" => :mojave
    sha256 "cbd28cdd37c3a1577ef59374be3aae1c445a5f2dd79cdb57cbc5aae2908866c7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
