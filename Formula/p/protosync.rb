class Protosync < Formula
  desc "Synchronise remote .proto files to a local directory"
  homepage "https://github.com/cashapp/protosync"
  url "https://github.com/cashapp/protosync/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "2ef679764b687bb79fd897aebaf70796cb6df8560fbb122d780da628b6abd5c9"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"protosync"), "./cmd/protosync"
  end

  test do
    assert_match(/^Usage: protosync/, shell_output("#{bin}/protosync --help"))
  end
end
