class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find."
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v1.1.0.tar.gz"
  sha256 "05993180251a5c2c29c95ce0765bacfa9906eb6c4c6570be4e18faa5b31c1817"
  head "https://github.com/sharkdp/fd.git"

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
