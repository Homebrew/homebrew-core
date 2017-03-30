class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.4.1.tar.gz"
  sha256 "1005f320aabc776971ac2adb422eaae001d7adafac47f67c9000f94e70c3b56a"
  head "https://github.com/ogham/exa.git"

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
