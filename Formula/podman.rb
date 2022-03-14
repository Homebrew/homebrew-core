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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8272a253e9cfcf0cf7195b030224b225ac0fdf3c85b65b2f46d3d0a3243f465d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a30a4bd37114951e39c1379465151c2e7717c25101968f1ff56bea6943bf5f7"
    sha256 cellar: :any_skip_relocation, monterey:       "d5ca8fca094186a1f55b6295430aa2257c7328f187d6e66a926673b9c1378307"
    sha256 cellar: :any_skip_relocation, big_sur:        "df6c3831dd67059236a9939b6d9ba51b0c6aa8f0835bcaf9942ca59fca085b6e"
    sha256 cellar: :any_skip_relocation, catalina:       "cab8c60ba95ef720f5db1eafb4ff6b7e27e78550618c461985fc57e2995c0c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5292a602dbe54d82e224f2350a91e183919c35ecb7ddde71e60ebb8b91df84e8"
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
