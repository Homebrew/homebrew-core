class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v2.2.1.tar.gz"
  sha256 "bd86b181251e2308cb52f18410fb52d89df7f130cecf0298bbf9a848fe7daf60"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f1b52e8e1fbb23a43ed7e961cb5e119d38aaa6abec767d1c795ffcbb5a08d8f" => :big_sur
    sha256 "2d4557414e96180dd119382303f932a685cfd9f810cb39c89e646f366d6e933c" => :arm64_big_sur
    sha256 "c495895437ba8d9fbc999a74d3d8e465f7980fc78b846b383c396e96a220e5d7" => :catalina
    sha256 "a608e53d52bfa2448c1ca8a48aa2702107d60bcd9bc351f4387c9c3922f3ca3f" => :mojave
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
