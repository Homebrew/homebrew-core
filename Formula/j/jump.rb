class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "b54bc4d1173be7ad5e4866f3b76f02c59506cc66b05fafe4aa3854cad1d2d531"
  license "MIT"
  head "https://github.com/gsamokovarov/jump.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "748682eed44f56971f34905be8df1497ac2db7e407ca0a6e3f5b2b0e2aa9eff4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "748682eed44f56971f34905be8df1497ac2db7e407ca0a6e3f5b2b0e2aa9eff4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "748682eed44f56971f34905be8df1497ac2db7e407ca0a6e3f5b2b0e2aa9eff4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c968580a05c97faac5046d4e03aa8faf2bc89008db64ff81e83b55cefaea2029"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d762b4bcfa955462e651c27b6781955bdc6d82f80f5975abfb0ba0421e3009a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb2c9042ebf1cdd8b15dcfc1f541e862917588fbfed90a40f5a60b69ed726d65"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"jump", "shell")
    man1.install "man/jump.1"
    man1.install "man/j.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system bin/"jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
