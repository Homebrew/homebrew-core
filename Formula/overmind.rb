class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.0.3.tar.gz"
  sha256 "88833b71d83ffcf40dce1314e62c19dc65e5acd51c8397e4149781c30e9fa73a"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "66e5376c20be89e3f12c9605353d52182102e45a018a4a930269e0c941b5cbb2" => :catalina
    sha256 "a71962febb318f1914fdc2c6715c749a76b12a48850f3d7d6506a81f966c54ea" => :mojave
    sha256 "b711bc71b4f5f45512a565fd2f17bd9db16881194fb6d0e0c2d917b7f0ef2d48" => :high_sierra
    sha256 "c4ed8a432dc73661f7a92f3d67db6d19e4a765cde72591c7df1fb11f8d450291" => :sierra
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/DarthSim/overmind").install buildpath.children
    system "go", "build", "-o", "#{bin}/overmind", "-v", "github.com/DarthSim/overmind"
  end

  test do
    expected_message = "overmind: open ./Procfile: no such file or directory"
    assert_match expected_message, shell_output("#{bin}/overmind start 2>&1", 1)
    (testpath/"Procfile").write("test: echo 'test message'")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/overmind start")
  end
end
