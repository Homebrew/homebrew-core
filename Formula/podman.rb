class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/containers/podman/archive/v3.4.1.tar.gz"
    sha256 "3fa70c499a4733524354518e839eefa3f14b630a519393418d082880535c1e33"

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.2.0.tar.gz"
      sha256 "a54da74d6ad129a1c8fed3802ba8651cce37b123ee0e771b0d35889dae4751fc"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4984651d23c23952d64afdae629b15c92e1f48c2b9dda7a3a0f04de964d9f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c870ada3226fbce07c85c61e034cf5c4de95982c145cb454eb1ef3ef5689cce"
    sha256 cellar: :any_skip_relocation, monterey:       "5c675998810646c572bf5fc5c587a6ecdffb791c4508010a9a17956cb60ff41d"
    sha256 cellar: :any_skip_relocation, big_sur:        "634485b9eb2434314f8e4a16541e32097c38609db6f20317149a7981dcc30b11"
    sha256 cellar: :any_skip_relocation, catalina:       "948dbdb483e570ee58e2c85ad9738d00c6aa95ddceea3d7d44bb7888e8fcba79"
    sha256 cellar: :any_skip_relocation, mojave:         "a0e6ca9d6ddced8a61fb48bfca552e1617bc32eea0238b941f02266c317953d4"
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
    os = OS.kernel_name.downcase

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

    if build.head?
      system "make", "podman-remote-#{os}-docs"
    else
      system "make", "install-podman-remote-#{os}-docs"
    end

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
