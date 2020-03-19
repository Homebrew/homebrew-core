class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.1.1.tar.gz"
  sha256 "250d60bebb5d353b449a34f4eae7e036e0b6f46bd23b2c7b8d333acff7c7a615"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "df98635534afa5d8f50dae0d94c22c322eb9207504286e2de3d893f48dd231be" => :catalina
    sha256 "71e26cd0de3036d27a040b163754b9d6e7d00756e15158ec24e9709b10b512c3" => :mojave
    sha256 "749729e78f9702a2a2523a6f31c2a157a4266aeabc8e3a54b69cacad5edfc897" => :high_sierra
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
