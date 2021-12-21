class Kubecolor < Formula
  desc "Colorizes kubectl output"
  homepage "https://github.com/hidetatz/kubecolor"
  url "https://github.com/hidetatz/kubecolor/archive/v0.0.20.tar.gz"
  sha256 "c8a22cb9aeb2c9a564523752694a687a448da0b4c79dcc9e05bf084431f0dc5b"
  license "MIT"
  head "https://github.com/hidetatz/kubecolor.git", branch: "main"

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/kubecolor"
  end

  test do
    assert_match "server localhost:8080 was refused", shell_output("#{bin}/kubecolor get pods 2>&1", 1)

    assert_match "error: current-context is not set",
      shell_output("#{bin}/kubecolor config current-context 2>&1", 1)
  end
end
