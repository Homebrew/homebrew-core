class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.4.1.tar.gz"
  sha256 "1005f320aabc776971ac2adb422eaae001d7adafac47f67c9000f94e70c3b56a"
  head "https://github.com/ogham/exa.git"

  bottle do
    cellar :any
    sha256 "a56feb823f55ead6683087e9aca48d86b9610896a0a7b738e3359e8f4cb8ce31" => :sierra
    sha256 "dec140f9b80302b23c231a373daa9993f56d7070b01248b0583eadafe05726aa" => :el_capitan
    sha256 "36379d3dc4cbfce03e5ebd7f4009240ba78a6388912f43ff57d241411b5d3d96" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "libgit2" => :recommended

  def install
    args = ["--release"]
    args << "--no-default-features" if build.without? "libgit2"

    system "cargo", "build", *args
    bin.install "target/release/exa"
    man1.install "contrib/man/exa.1"
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
