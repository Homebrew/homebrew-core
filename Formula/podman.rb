class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/containers/podman/archive/v4.0.2.tar.gz"
    sha256 "cac4328b0a5e618f4f6567944e255d15fad3e1f7901df55603f1efdd7aaeda95"
    # This patch is needed to allow proper booting of the machine as well
    # as volume mounting with 9p on darwin. It is already merged upstream
    # and can be removed at Podman 4.1.
    patch do
      url "https://github.com/containers/podman/commit/cdb6deb148f72cad9794dec176e4df1b81d31d08.patch?full_index=1"
      sha256 "10d1383f4179fd4af947f554677c301dc64c53c13d2f0f59aa7b4d370de49fcf"
    end
    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.3.0.tar.gz"
      sha256 "6ca454ae73fce3574fa2b615e6c923ee526064d0dc2bcf8dab3cca57e9678035"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de3f685d459bdc3c3fab15350fe7890162127f3417feeda02a47c30b087e4f43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3aa72594f5429b158efe69a2f32954716f6f86a2d0c029f60648ad2a10ddfa84"
    sha256 cellar: :any_skip_relocation, monterey:       "37152fb080b558ca6a03512b6053e2762a7af821469a720fe36ef098ae238475"
    sha256 cellar: :any_skip_relocation, big_sur:        "b767e062d7e101b8240d6f781e74ab1345c194551264ef62ad84b96939184591"
    sha256 cellar: :any_skip_relocation, catalina:       "a8ae8fb04b098cd105a657579decc6462676bd78aee1c1c5b5cdfc6ae28835db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdeb28c670a8d73babf3580b62ffc285afd460da7159c4bca0afd807a1ccad1c"
  end

  head do
    url "https://github.com/containers/podman.git", branch: "main"

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock.git", branch: "main"
    end
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "qemu"

  def install
    ENV["CGO_ENABLED"] = "1"
    os = OS.kernel_name.downcase

    inreplace "vendor/github.com/containers/common/pkg/config/config_#{os}.go",
              "/usr/local/libexec/podman",
              libexec

    system "make", "podman-remote-#{os}"
    if OS.mac?
      bin.install "bin/#{os}/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"
    else
      bin.install "bin/podman-remote"
    end

    resource("gvproxy").stage do
      system "make", "gvproxy"
      libexec.install "bin/gvproxy"
    end

    system "make", "podman-remote-#{os}-docs"
    man1.install Dir["docs/build/remote/#{os}/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
    fish_completion.install "completions/fish/podman.fish"
  end

  test do
    assert_match "podman-remote version #{version}", shell_output("#{bin}/podman-remote -v")
    assert_match(/Cannot connect to Podman/i, shell_output("#{bin}/podman-remote info 2>&1", 125))

    machineinit_output = shell_output("podman-remote machine init --image-path fake-testi123 fake-testvm 2>&1", 125)
    assert_match "Error: open fake-testi123: no such file or directory", machineinit_output
  end
end
