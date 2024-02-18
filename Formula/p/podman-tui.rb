class PodmanTui < Formula
  desc "Podman Terminal UI"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui.git",
    tag: "v0.17.0"
  head "https://github.com/containers/podman-tui.git", branch: "main"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]

  depends_on "go" => :build
  depends_on "make" => :build

  def install
    if OS.mac?
      system "make", "binary-darwin"
      bin.install "bin/darwin/podman-tui" => "podman-tui"
    else
      system "make", "binary"
      bin.install "bin/podman-tui" => "podman-tui"
    end
  end

  test do
    assert_match "podman-tui #{version}", shell_output("#{bin}/podman-tui version")
  end
end
