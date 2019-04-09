class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.12.tar.gz"
  sha256 "282d7ac60756507eec752e37747aedeaa74bc335d7c3c17c2987044520c23723"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e687e38fefc0938888c2a2ab4295090b2a924c7677d9201f59c6c3b71778aa1" => :mojave
    sha256 "890e0f94b9a83b36719830f64dd4df261a8837c0c8f204b5efe43a0c6b39b72b" => :high_sierra
    sha256 "9e007833b0ff6936bdf13631435004db18654d1c8ecff573134a29d23781cd1c" => :sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
