class Ku < Formula
  desc "Keyboard-driven Kubernetes terminal interface"
  homepage "https://github.com/bjarneo/ku"
  url "https://github.com/bjarneo/ku/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "8ee6560203f5a2aebea6cd22b1349ac22745899cd37dbe76ddc611c4ecb1c075"
  license "MIT"
  head "https://github.com/bjarneo/ku.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ku --version")

    (testpath/"kubeconfig").write("")
    output = shell_output("#{bin}/ku --check --kubeconfig #{testpath}/kubeconfig 2>&1", 1)
    assert_match "kubeconfig is empty or missing", output
  end
end
