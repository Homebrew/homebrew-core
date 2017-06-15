class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find."
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v2.0.0.tar.gz"
  sha256 "240bc7e6eb143a7bc80a88a31c2c790ab078b42d459e72b4c86a340975083bd3"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "698a78bb0f8bcb4b6436bbd1e8e6bdaacf63e40abf3e11328ccb16d29e6a48be" => :sierra
    sha256 "95f737aee53f8e778b3faa116dcc0955ce64b2c1e5c1ede560df22630738b158" => :el_capitan
    sha256 "4e389d1a5fa55ac5e496ffce01944b13c1a996402ea6f136b69a24401f1acbbd" => :yosemite
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
