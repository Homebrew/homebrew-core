class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find."
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v2.0.0.tar.gz"
  sha256 "240bc7e6eb143a7bc80a88a31c2c790ab078b42d459e72b4c86a340975083bd3"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "fe301dceae7cac1fd9ce997a296670347b7e23774bd05ec7a2119c14ee33fbdf" => :sierra
    sha256 "80d018141b75c5214d037e217bd7d5ef7bae5d2cc8bda2a2e83abbf7c7924a7d" => :el_capitan
    sha256 "a5be812d4ce9b0553c8dd1e5f1e1917b309bee582965bd21fd29798a6a5c5426" => :yosemite
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
