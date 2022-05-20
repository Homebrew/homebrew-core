class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.41.0.tar.gz"
  sha256 "833151da3e9dc09190588c0a381116e3dfdf5b728869cb7b96681eb59c452b4c"
  license "MIT"
  head "https://github.com/gsamokovarov/jump.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1f200b2d8848305139c76e468725599fc4647a80a7b54e1394abbdb4fbb1c16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1f200b2d8848305139c76e468725599fc4647a80a7b54e1394abbdb4fbb1c16"
    sha256 cellar: :any_skip_relocation, monterey:       "09697911ef3c008e4105828b6ee8ca4be2ffeb774fa1676d5de9de9efcaeae52"
    sha256 cellar: :any_skip_relocation, big_sur:        "09697911ef3c008e4105828b6ee8ca4be2ffeb774fa1676d5de9de9efcaeae52"
    sha256 cellar: :any_skip_relocation, catalina:       "09697911ef3c008e4105828b6ee8ca4be2ffeb774fa1676d5de9de9efcaeae52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a6c2c2b029b816f95f5fb029b9d5857719553542bf485414f5f127c5dc8dede"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
    man1.install "man/j.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
