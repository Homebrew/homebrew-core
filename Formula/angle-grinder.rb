class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.14.1.tar.gz"
  sha256 "32ee1ae9102f81b6d6a3c0865c42e2c747595804d5b8689a2e6a1e39ed0cd886"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f56817a1ba74f6bf2f3ce2eecf6543a7799cd7ab531f1bcf679a2d86a7f1055" => :catalina
    sha256 "814132150ae7f4aff91fdbcba1dd9a2a79712db2a67ec98d0c35d4cb153d4bc0" => :mojave
    sha256 "e944a8e711c0be515f945c645bde96a4bddd43a54ab96fac5e0dd04a548654f4" => :high_sierra
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
