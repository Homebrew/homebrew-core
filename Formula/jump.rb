class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.30.0.tar.gz"
  sha256 "4c9dc01790e5a28a9f62fcc4821839ae054be60dbd3e3ed24d6fa49eac9ba15d"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "953aefe18f668dd77d0dfdfb8a068a5b9df541a923b619fc886efa3a812bf883" => :catalina
    sha256 "8f278ac52e247254c19a2a7a3a5c3ae1972c61266600080b4c47b3dfc118066a" => :mojave
    sha256 "05b7f315b38908f1f936ccfae5fcb026294c0daaaafbd9c6cda885ca43b3b9eb" => :high_sierra
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
