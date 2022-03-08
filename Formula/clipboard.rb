class Clipboard < Formula
  desc "Better command-line clipboard"
  homepage "https://github.com/amilajack/clipboard"
  url "https://github.com/amilajack/clipboard/archive/v0.0.1.tar.gz"
  sha256 "92042d36cfe999283ad98143865360bf039fc12cf96902491a24c80fb85416e0"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.txt").write("Hello World")
    shell_output("#{bin}/cb #{testpath}/test.txt")
    output = shell_output("#{bin}/cb")
    assert_match "Hello World", output
  end
end
