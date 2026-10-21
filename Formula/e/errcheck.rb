class Errcheck < Formula
  desc "Finds silently ignored errors in Go code"
  homepage "https://github.com/kisielk/errcheck"
  url "https://github.com/kisielk/errcheck/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "0c7b3bfdc9cc659d87c6ed72eb8980e4740e2990a6243a6e67743394ea1c20ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00cac7449214a85a9b27425cc474e78c38f48fa2d95339890e42173e0bad7c75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00cac7449214a85a9b27425cc474e78c38f48fa2d95339890e42173e0bad7c75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00cac7449214a85a9b27425cc474e78c38f48fa2d95339890e42173e0bad7c75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3f2abd17014e5b0f34e6246d4a570846fe84d1fde385dd62a98a4ba6d2ba5f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "91d75e39476e6af241d16e53090ba46a415ccc52c2bd226fb71071b12d68b42a"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    pkgshare.install "testdata"
  end

  test do
    system "go", "mod", "init", "brewtest"
    cp_r pkgshare/"testdata/.", testpath
    output = shell_output("#{bin}/errcheck ./...", 1)
    assert_match "main.go:", output
  end
end
