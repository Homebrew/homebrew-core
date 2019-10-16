class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.12.0.tar.gz"
  sha256 "a27d8776684ac704114ef9f721c55eb9d41926907985132f2ecb7db15f3932c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb9320f378795c456d775614c7a08e0c2df7c447cf3be700142bbef988f59f41" => :catalina
    sha256 "e7e27623aad3f772486810f151621f93c9112d58297ede293d7cbde051f4553e" => :mojave
    sha256 "4071b07d97fab4660b6089e3f51e0a791ebe36170283d410fa91aa0d4cb84105" => :high_sierra
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
