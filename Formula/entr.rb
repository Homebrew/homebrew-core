class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-4.6.tar.gz"
  sha256 "16de20820df4a38162354754487b1248c8711822c7342d2f6d4f28fbd4a38e6d"
  license "ISC"
  head "https://github.com/eradman/entr.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "014e80aa42f3793499133711e30b9d4b626789482f558aad60d2e864d2c5bbd0" => :big_sur
    sha256 "f1b1b9b34ced4b9ac9b365e16673ca1030040dda599524316d0f9952cbfe07d9" => :arm64_big_sur
    sha256 "21b69b1e641551d2022f5b261fd03d43e16e54d7eb09528890d122968de12460" => :catalina
    sha256 "26cae580f66328a940c9f13add3c4cf91fae6b01247144a302757aac11e53427" => :mojave
    sha256 "f37ebf2d5da20610536902c4010e4cd93136bc6282f2f3c7a119e3876c79d447" => :high_sierra
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -p -d echo 'New File'", testpath).strip
  end
end
