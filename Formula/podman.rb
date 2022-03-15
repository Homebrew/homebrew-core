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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c657ea70f1ad41e79cb869f1fa3921b3138e8d2dfb4b28bcee038aaf872b9973"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8b1a8c93b2145b1e9325523ae509b592fcb3b7d00b57ddcdb8a8bf20974be2f"
    sha256 cellar: :any_skip_relocation, monterey:       "8bcecedc15e1e467319440529e269d16e5eb6ed652817f39602ebb4fe2904696"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad4a1c14ba0ee1de7bf8cd73a1a631eb3d8753536c44ae49503f914a432e3139"
    sha256 cellar: :any_skip_relocation, catalina:       "87d1dfea218f0de9bcf2abc7198d3b73cfd4f12398d70787d292281977259458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f14ce9713781868a0c17f83b7affe88dbc739c72d19c6e61a10a820b7fdc347c"
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
