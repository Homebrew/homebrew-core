class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https://github.com/theryangeary/choose"
  url "https://github.com/theryangeary/choose/archive/v1.3.1.tar.gz"
  sha256 "6c44170f456f410370ba31d59bfad1f54a71ba80a79b87debbe235672a2ea0dd"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fc92343f3271b68c34297dc3b5be11c613cbbe3859a19b0fa77458e3a4c4062" => :catalina
    sha256 "8ae1baa55d848f0cbdb3833ce5cc257870b0f4edd84e7d0e61c84ebd3ba1b510" => :mojave
    sha256 "d8a10d3ad72b6b5c80f3656e2bab071eab67ba225959518283c1940d19707fd7" => :high_sierra
  end

  depends_on "rust" => :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-gui", because: "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}/choose -f ',\\s*' 1..=2", input).strip
  end
end
