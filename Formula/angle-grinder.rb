class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.13.0.tar.gz"
  sha256 "514e9edf033c633bf559f5cc3db365f3701f6d937d57a4e6718f525a20447bde"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cd030afe0fdd2879bdf9db6e060a0d003cab1fcd017ee9900f49155e99b24ee0" => :catalina
    sha256 "59333e0ccb022eba3f3f2b8e448e658533636665632e0368386c4e15e7713804" => :mojave
    sha256 "9450f13f39e8a57a55634625f654594d7c1be801530b785d4ff9a1e6df92f316" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
