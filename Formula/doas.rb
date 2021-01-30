class Doas < Formula
  desc "Execute commands as another user or root"
  homepage "https://github.com/slicer69/doas"
  url "https://github.com/slicer69/doas/archive/6.3p4.tar.gz"
  version "6.3p4"
  sha256 "e6dff62c7e38f8002ac0936f636432c52cf767f01ba703bf8723456b3c43e6de"
  license "BSD-2-Clause"
  head "https://github.com/slicer69/doas.git"

  def install
    system "make", "install", "DESTDIR=", "PREFIX=#{prefix}"
  end

  def caveats
    "The file at /etc/pam.d/sudo needs to be copied to /etc/pam.d/doas in order for doas to work"
  end

  test do
    # not much else can be done without the PAM file known to be in place
    assert_predicate bin/"doas", :exist?
    assert_predicate bin/"vidoas", :exist?
  end
end
