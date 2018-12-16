class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.7.6.tar.gz"
  sha256 "680ff41b015a276822aaeea55d7666e1b0208790a2fb4e22cb7a3d181a898542"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fbd35f4a2d8dbaa44a81e63326695e25034d35e56b8dc26b73a851e920e4b39" => :mojave
    sha256 "af65167e605fc61c5402278cd2f298bdbdf970d4cb5c5ee3a9c2ebf66dd793be" => :high_sierra
    sha256 "ed97ec593e1d3a43d5f5c97a7775d8bffef1532509fd9220c62751109573a026" => :sierra
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
