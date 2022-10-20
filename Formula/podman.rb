class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/containers/podman/archive/v4.2.1.tar.gz"
    sha256 "b10004e91a9f5528da450466ec8e6f623eaa28ada79e3044c238895b2c8d1df3"

    # Allow specifying helper dirs with $BINDIR as base directory. Use a `$BINDIR` magic
    # token as a prefix in the helper path to indicate it should be relative to the
    # directory where the binary is located.
    # This patch can be dropped on upgrade to podman 4.3.0.
    patch do
      url "https://github.com/containers/common/commit/030b7518103cfd7b930b54744d4a4510b659fdc2.patch?full_index=1"
      sha256 "7c00abe7728d6438abcdb69ce6efa43503dcbb93bcb2d737f6ca4aa553e2eeb5"
      directory "vendor/github.com/containers/common"
    end

    # Update Darwin config to include '$BINDIR/../libexec/podman' in helper search path.
    # This patch can be dropped on upgrade to podman 4.3.0.
    patch do
      url "https://github.com/containers/common/commit/4e6828877b0067557b435ec8810bda7f5cb48a4f.patch?full_index=1"
      sha256 "01c4c67159f83f636a7b3a6007a010b1336c83246e4fb8c34b67be32fd6c2206"
      directory "vendor/github.com/containers/common"
    end

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.4.0.tar.gz"
      sha256 "896cf02fbabce9583a1bba21e2b384015c0104d634a73a16d2f44552cf84d972"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a7443b447e60d3f96b523e16f6f87f2ce85373ca8d9225ae21b172fc95a1ea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a56477a832e836895b1fa7f9847f80d4c3e55ef4b1409c8d14bee06d8b4c1e4d"
    sha256 cellar: :any_skip_relocation, monterey:       "f5cd5677ba4ff64682eeecb8422ae58bba5327d28480960bc315a6cebea13167"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dd0b75f8496dfe0c3bb618d8194a2ce7e5521881383045385ecbc3225f2e007"
    sha256 cellar: :any_skip_relocation, catalina:       "0f443433962a0fc1555da4e75550aae083075c66c438d38ef98dde1dbeb67eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64e188e78c05935c6d73713f69ffae54452082e01b9d3f8f7a64c160c302fe9"
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

    # Update helper binary location to look at libexec/podman inside the keg.
    # This is not needed on Mac because config_darwin.go already includes this
    # location, but Linux doesn't so let's add it through the environment
    # variable. Note that we want a literal `$BINDIR`, so we need to escape
    # the `$` for Makefile syntax, so we need to double it as `$$BINDIR`.
    ENV["HELPER_BINARIES_DIR"] = "$$BINDIR/../libexec/podman" if OS.linux?
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
      (libexec/"podman").install "bin/gvproxy"
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
