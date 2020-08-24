class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.15.0.tar.gz"
  sha256 "5359d6e241eca2bc3bdb7ddf9344b4ef8315cbe7629775c09e0ab7ed70310c8d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f395c2d4997cd855ed3a8dc2ddf978b04fb59c9868509f5b9b2b02c2ac13aa7c" => :catalina
    sha256 "dfa85c12e520c3d57206f376cce51a7e52b4f486d586d47fabcefa6508b06514" => :mojave
    sha256 "6025f925c0d03b7bb6b020e7c4ea859eed3c6244bd9065d0e78c34ec140b3361" => :high_sierra
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
