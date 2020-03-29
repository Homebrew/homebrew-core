class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.13.0.tar.gz"
  sha256 "b257b9869f5350bc75754ecdd883341a7ede74bde05dd1e934dfd3b40d962d7c"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ab4027c863beaa9da3593844c89465ec95ba88d829ef76b4eb0b6c648d01af9a" => :catalina
    sha256 "5d1c7560b7a8e0437d7534253ad360d9d5d0560d2d8f2e092461691faf0e30fa" => :mojave
    sha256 "4aedebd2abddc24893f849fd86830efc1247739782fdf239ea04ef6cf25fcd2b" => :high_sierra
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
