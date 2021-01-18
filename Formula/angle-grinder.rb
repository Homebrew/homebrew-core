class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.16.tar.gz"
  sha256 "575e5398cfcddc78152f76ade632f7be2aa6b54b4adaaf1776344529fb9c0561"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a1256b4d29478fbaf24b5683d1a97f78c5acce41292f5e49c164545c197388b" => :big_sur
    sha256 "4ff200cdd8142e3d16a89a3050c690be506023da7ea6c6ca59700a209aa647dd" => :arm64_big_sur
    sha256 "15943cf324e460ab66b499fe6399c8da05b305289ef42e5dfc385ca2e3c7177d" => :catalina
    sha256 "4b3d867ea87b7c6a478aa7e6e5ea5909e01946c59473d4467254298c2ec524e8" => :mojave
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
