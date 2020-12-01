class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v2.2.0.tar.gz"
  sha256 "ec5473e51fa28f29af323473fc484f742dc7df23d06d8ba9f217f13382893a71"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4223c3e232403a0879a0fbf98004c6fb512618aa9d4ae9468104e33dca7a99fa" => :big_sur
    sha256 "eb411460ee3d91f8286df3eadd4dfd0fec63d61e29a8a6c29c581ac073642011" => :catalina
    sha256 "09967354204cdd075332de1ba2eaf39ae154da5167200ead9e2db38d96f7a96b" => :mojave
    sha256 "fb2ca2c9370177bddf1f1683cef3d121fbdb72126a3999eddc097f20ec637540" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "podman-remote-darwin"
    bin.install "bin/podman-remote-darwin" => "podman"

    system "make", "install-podman-remote-darwin-docs"
    man1.install Dir["docs/build/remote/darwin/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
  end

  test do
    assert_match "podman version #{version}", shell_output("#{bin}/podman -v")
    assert_match "Error: Get", shell_output("#{bin}/podman info 2>&1", 125)
  end
end
