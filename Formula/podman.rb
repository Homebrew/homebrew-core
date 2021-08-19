class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.2.3.tar.gz"
  sha256 "ddb8a83d21d2f496512914820525b4c959ff0902d48caaf93a005854a9069b59"
  license "Apache-2.0"
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5126a369ece72f175f35ebd723dd37cf2b641f6dd91b15cee5922b0ebb77fc51"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad15ab1c0112445efa37f4259323560f4d34e432cc25c7aa7caa83de4d24933d"
    sha256 cellar: :any_skip_relocation, catalina:      "e942f0720bcf480b53033fa116c0618809f30daba45b65cedec59c0263d2c42a"
    sha256 cellar: :any_skip_relocation, mojave:        "0f50f0a14dd78993bc73e2fae892ed83c07f5ff3b6e5e41a89d900324e275031"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "qemu" if Hardware::CPU.intel?

  resource "gvproxy" do
    url "https://github.com/containers/gvisor-tap-vsock/archive/v0.1.0.tar.gz"
    sha256 "e1e1bec2fc42039da1ae68d382d4560a27c04bbe2aae535837294dd6773e88e0"
  end

  def install
    os = if OS.mac?
      "darwin"
    else
      "linux"
    end

    system "make", "podman-remote-#{os}"
    on_macos do
      bin.install "bin/#{os}/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"
    end
    on_linux do
      bin.install "bin/podman-remote"
    end

    resource("gvproxy").stage do
      system "make"
      bin.install "bin/gvproxy"
    end

    system "make", "install-podman-remote-#{os}-docs"
    man1.install Dir["docs/build/remote/#{os}/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
    fish_completion.install "completions/fish/podman.fish"
  end

  test do
    assert_match "podman-remote version #{version}", shell_output("#{bin}/podman-remote -v")
    assert_match(/Error: Cannot connect to the Podman socket/i, shell_output("#{bin}/podman-remote info 2>&1", 125))
    if Hardware::CPU.intel?
      machineinit_output = shell_output("podman-remote machine init --image-path fake-testi123 fake-testvm 2>&1", 125)
      assert_match "Error: open fake-testi123: no such file or directory", machineinit_output
    end
  end
end
