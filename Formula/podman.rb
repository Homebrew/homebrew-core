class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/containers/podman/archive/v4.2.0.tar.gz"
    sha256 "15f8bc59025ccd97dc9212a552e7274dfb79e1633b02d6a2a7f63d747eadb2f4"

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.4.0.tar.gz"
      sha256 "896cf02fbabce9583a1bba21e2b384015c0104d634a73a16d2f44552cf84d972"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90ed05f03840e3c98397fb9833d65deef5c14640ded372fddf58beda91980bb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdf752ce452ab9af35be05228806e99c9655b840cac5b9081424338ee21d0025"
    sha256 cellar: :any_skip_relocation, monterey:       "189613a7061ed62fca23c0bb92553536fafb503f19072d3552485268ac1d4fe6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9ad0036f5b4a2c83c1d3ac4cf8e7d6931e46ce62febd69a50c9fcf803a10461"
    sha256 cellar: :any_skip_relocation, catalina:       "db46307c9571b23459e979336906f56376a21920f5b6a0447c79c65d5cd48a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "291babc343bc2976a95d55ab2c81735f3cd48b3932a098d156d3dc9395679cf9"
  end

  head do
    url "https://github.com/containers/podman.git", branch: "main"

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock.git", branch: "main"
    end
  end

  depends_on "go-md2man" => :build
  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build
  depends_on "qemu"

  def install
    ENV["CGO_ENABLED"] = "1"
    os = OS.kernel_name.downcase

    inreplace "vendor/github.com/containers/common/pkg/config/config_#{os}.go",
              "/usr/local/libexec/podman",
              libexec

    system "make", "podman-remote"
    if OS.mac?
      bin.install "bin/#{os}/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"
      system "make", "podman-mac-helper"
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
