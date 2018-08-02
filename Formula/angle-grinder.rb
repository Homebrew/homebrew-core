class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.7.5.tar.gz"
  sha256 "9d99ae18666f0e63fe7aef9ad4eed18440d4f395329ef616758d087b9b1f758b"

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
