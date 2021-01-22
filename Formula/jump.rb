class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.40.0.tar.gz"
  sha256 "f005f843fc65b7be1d4159da7d4c220eef0229ecec9935c6ac23e4963eef645e"
  license "MIT"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "583050c8b842e4923e6f654ad3f1a1db1fe3b994c5bd0b5fa7912a682b5a9866" => :big_sur
    sha256 "0dd02ec543d3d9ba54627396603c9a9df477e92f2be1ce50bf66ce004f078b8f" => :arm64_big_sur
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
