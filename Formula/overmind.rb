class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.1.1.tar.gz"
  sha256 "250d60bebb5d353b449a34f4eae7e036e0b6f46bd23b2c7b8d333acff7c7a615"
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
