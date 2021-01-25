class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.16.tar.gz"
  sha256 "575e5398cfcddc78152f76ade632f7be2aa6b54b4adaaf1776344529fb9c0561"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "25e2cec189b99c508be9de6ef7076028e49dfb8c806bb2c0637071c4c4479f6a" => :big_sur
    sha256 "15d4fb499d5ba409e212603382bfa5277d24d84ab53561fb78bbb14ac1e6bfaa" => :arm64_big_sur
    sha256 "567fb4aea30314ed1ff6b5bfe07b84ccdebaadf5de7e150c849fd2bd59fe020b" => :catalina
    sha256 "003d5093badf3df2e29df03a0098d1ad346f788979e03568638c5c7067168112" => :mojave
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
