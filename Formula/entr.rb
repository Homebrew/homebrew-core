class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-4.4.tar.gz"
  sha256 "54566c64f360afd43f6a6065bc6d849472337edf2189b1ce34bf15b611f350f4"
  head "https://github.com/eradman/entr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "98f508565c8dd087b780fda140099fca3afb457ca27fcf3864bb508c87c403cc" => :catalina
    sha256 "d18935ecc0bf78504d6acd00b2adb889389af2586cafc2602e38599f2590183f" => :mojave
    sha256 "25fba36721d2857ca91efc7b82a8cbe15ff0a83f20e9febe57648fc173377629" => :high_sierra
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
