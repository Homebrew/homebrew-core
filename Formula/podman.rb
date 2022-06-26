class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/containers/podman/archive/v4.1.1.tar.gz"
    sha256 "27bf32e9b1afee94cb08ebd59389104788d687f402a541f3631f94c7916b10a5"
    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.3.0.tar.gz"
      sha256 "6ca454ae73fce3574fa2b615e6c923ee526064d0dc2bcf8dab3cca57e9678035"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0389d5ec1489959bc7ff0a558ebf9816317942d5de988cf1739e1c0fc667b598"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11d99816bb8cd41781a5d312a1547a89180536fb445445336c637c7d46e9ded3"
    sha256 cellar: :any_skip_relocation, monterey:       "f04d10389ef24a0a258ce1e5ddf14f290420eaff555f58ecdf1495f930ae90f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a8967d5b501cbccd23f943971d56b36ac7f0694962ea153c50e6727f933a9a3"
    sha256 cellar: :any_skip_relocation, catalina:       "2fbadb9d67779137c4a26f402bd7f8414d98e693c6809268131b7abc8e4a9a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1997012b073de38e3c113c15e29f3dae12b0e09f93cc3e30fc6003a6e808102"
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

  # Fixes compatability with qemu 7.0.0. Can be removed next release.
  # See: https://github.com/containers/podman/issues/14303
  patch do
    url "https://github.com/containers/podman/commit/9fac1b335f681400a029e9d8014f45fa5634ec40.patch?full_index=1"
    sha256 "161a0ce3d1012ae030790a16857278e4417b3b410dce68927a6b02a43cf090ba"
  end

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
      bin.install "bin/#{os}/podman-mac-helper" => "podman-mac-helper"
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
