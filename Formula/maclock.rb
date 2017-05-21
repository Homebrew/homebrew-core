class Maclock < Formula
  desc "Triggers Immediate screen lock on macOS"
  homepage "https://github.com/jcostom/maclock"
  url "https://github.com/jcostom/maclock/archive/1.0.tar.gz"
  sha256 "a0b8090e7bcf3b3cabc20d6e9fe2536f0d06f74e7a2367c2fea9cccbc5b16a24"

  def install
    system ENV.cc, "-framework", "Foundation", "maclock.m", "-o", "maclock"
    bin.install "maclock"
  end
  test do
    # A dummy test definition
    # As the program is quite trivial, not a lot to test here, unless
    # we want to lock your screen. :-)
    system "true"
  end
end
