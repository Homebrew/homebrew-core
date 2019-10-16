class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.12.0.tar.gz"
  sha256 "a27d8776684ac704114ef9f721c55eb9d41926907985132f2ecb7db15f3932c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a3e617eb5f8bae6828661ef71435709e023bb159fd841186873f43e70efd340" => :catalina
    sha256 "9dcda46bbacf98eedfa9911fa82e6cc4372f896bdbae20370c9b70aed344a83c" => :mojave
    sha256 "ac57327f819d4fe13f54366f7927c1765e030d84e2e62d22ad468f8769912f10" => :high_sierra
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
