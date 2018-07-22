class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.7.3.tar.gz"
  sha256 "2993c05c927b2e2a7fd5bf5211bcfce715f747c3889c25c351a34a60e021d50a"

  bottle do
    sha256 "77303c918071cc2d29bceb994bb2642ca507ed14254a3eea0f68af5e4b98482b" => :high_sierra
    sha256 "c7d3caf7625680bbfea59b75de3d8d425ddfe1b3d730373b954b1e57a0d7aa91" => :sierra
    sha256 "936133040ca7d68c05f799afb57cde2f21037561431b06efd350cbcbbde430d0" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
