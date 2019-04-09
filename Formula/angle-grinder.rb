class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.9.0.tar.gz"
  sha256 "230eb2bfbab73eb3ac5b37d25ab7521bc50f7640d9c12fcf50c3526eb4ba3423"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0bf9cc2953e28d9befb2d3645b08630b08372cfa36159116e0273a4ce1198de" => :mojave
    sha256 "dea7e6e77b0220f1d99b5b803cc57909cce80c1c6f4cf5f6919fafb2244d801f" => :high_sierra
    sha256 "e5371927492fb36f8b08479cf06de365b53c38252bc3e25f1c3858636d003b6d" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
