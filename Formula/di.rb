class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://gentoo.com/di/di-4.43.tar.gz"
  sha256 "c8374d2ab7a82274d733be01639f48440accf4c70c70b152f5fa3b1c8a9745e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8366dd18b3af3ee4539dddf27ca01480ca7456d6d9747c7c0fdd748acb3c5609" => :sierra
    sha256 "7636f4122c876f85c8b5030b2fba71fbb4d408af182b3aaa3efe5ed8d0e2045f" => :el_capitan
    sha256 "d476ffdabbd6eb1eeb552215d8a4ebe23c33577dbbba1bb72c163d771d7fc245" => :yosemite
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
