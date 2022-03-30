class Paperkey < Formula
  desc "Extract just secret information out of OpenPGP secret keys"
  homepage "https://www.jabberwocky.com/software/paperkey/"
  url "https://www.jabberwocky.com/software/paperkey/paperkey-1.6.tar.gz"
  sha256 "a245fd13271a8d2afa03dde979af3a29eb3d4ebb1fbcad4a9b52cf67a27d05f7"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?paperkey[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "71c9db30e077414c7504d8b20e9f5809b2cde37997881c1715e51e953d90d76d"
    sha256 cellar: :any_skip_relocation, big_sur:       "c6af240418bfb7c29113a1861966302d2be55fc578298f6fb0a4f71bc8dbf89e"
    sha256 cellar: :any_skip_relocation, catalina:      "12be9f841cfb0d4069be3e461cd5e783ba4ea11195507a13763f90ccc026f31e"
    sha256 cellar: :any_skip_relocation, mojave:        "894ef3339013be6574f736e316c61cbf54fbc3dcac358df14f1d54b1d7387854"
    sha256 cellar: :any_skip_relocation, high_sierra:   "82e49c6aa559a349ce73521a90881acb74a540de03d355ad7461c177d00bb8e8"
    sha256 cellar: :any_skip_relocation, sierra:        "fecd3e866173f93ddd6d89e91f2850d29c10e8edf27bb969a95de581ec382c56"
  end

  resource "homebrew-test_sec" do
    url "https://raw.githubusercontent.com/dmshaw/paperkey/46adad971458a798e203bf8ec65d6bc897494754/checks/papertest-rsa.sec"
    sha256 "0f39397227339171209760e0f27aa60ecf7eae31c32d0ec3a358434afd38eacd"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    resource("homebrew-test_sec").stage do
      system "#{bin}/paperkey", "--secret-key", "papertest-rsa.sec", "--output", "test"
      assert_predicate Pathname.pwd/"test", :exist?
    end
  end
end
