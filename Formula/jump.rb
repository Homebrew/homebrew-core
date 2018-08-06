class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.20.0.tar.gz"
  sha256 "8f4eba45110e7200dd06efb8f895ab9f2618ef2e25c7b892acee9b368c8de3a1"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0651ed704a154417fb45fa0ed02285c3287b07a3d5943ac76f84a422801aec79" => :high_sierra
    sha256 "74b1adb1b582f053d85bef2cec38cc6f77132970a7b3d9b95172314b0dfa67bc" => :sierra
    sha256 "f19300b1139c524f4d740a8ca7a52f489fab3096657ec0c8e9e807594a7c8cdf" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gsamokovarov").mkpath
    ln_s buildpath, buildpath/"src/github.com/gsamokovarov/jump"

    system "go", "build", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
