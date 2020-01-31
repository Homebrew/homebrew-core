class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.30.1.tar.gz"
  sha256 "76d6453246c047b49e669499dc1b6a7e4c4520653627461d84ad40c6afb45562"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d48416fa3c8f8d63107d3ab66fcf5285a0c3f00cb8d5c47c4b9864d0b42f5361" => :catalina
    sha256 "a171397df020999067bea07665fc9a1ea9e9613ff986f29167966fce0af4403e" => :mojave
    sha256 "5e5da5eede2cc2eed5d7ad16c0895227f0d79e1d80e7cf34c11d726cca61b847" => :high_sierra
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
