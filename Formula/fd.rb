class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find."
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v3.1.0.tar.gz"
  sha256 "03f35f808d4d4a7a5767ba791f259653edab0b9f6829233e98fd617f78a3faaf"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "a2d149054c7fd1b651a4cc6269d82b8498ffe9f0846157ec80db0023f0be35ec" => :sierra
    sha256 "9bd4b5373ac9b70127f8cf116ad32d3e9081875d11629f16383bdd84f092a067" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
