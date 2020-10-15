class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.30.1.tar.gz"
  sha256 "76d6453246c047b49e669499dc1b6a7e4c4520653627461d84ad40c6afb45562"
  license "MIT"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7399051ba9939abcfbca29e7f371315de6d55d1bd6fa9e1f7aa7d9ee947dd836" => :catalina
    sha256 "ba0fecff57b7efe0b984f55ad372bcb06c249f6df9353bab2cc648aef5c48ccf" => :mojave
    sha256 "450233293f93a80152625bfa6b965d7aa17dd5ee74f775e8adae414b41177250" => :high_sierra
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
