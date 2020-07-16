class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.2.0.tar.gz"
  sha256 "6c24fd91167f0fd35c60275f1cea9998c1ffab88a6b699731bf88f4e54f23d48"
  license "MIT"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "92947cadb4c81d86710dd03679ee41323c0a15481349f3d381c40551e9dc564c" => :catalina
    sha256 "173ee92b1df1bb52c09e0e7dcb7949774ed8abaa022a66f0d8d04699ab83f9b7" => :mojave
    sha256 "be3a5f096fd9495c2cdd4835751d759568a7cf1f16b85768b5dd3c1d73b9f40d" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"overmind"
    prefix.install_metafiles
  end

  test do
    expected_message = "overmind: open ./Procfile: no such file or directory"
    assert_match expected_message, shell_output("#{bin}/overmind start 2>&1", 1)
    (testpath/"Procfile").write("test: echo 'test message'")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/overmind start")
  end
end
