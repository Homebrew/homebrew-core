class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman.git",
      tag:      "v4.7.1",
      revision: "ef83eeb9c7482826672f3efa12db3d61c88df6c4"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a548b5f3abc24639883e76aa90de3f282c8342ac1a241083fa950826dcdfa934"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96ea874ca28fdbae4a7b4fd72f71b15e54553c17f0d2be893f5a2345ae4a8367"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d88ad41bf88b194d5bfbe3d201f1b4078b78913a88ead7707c180dcba0b85fdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "affb2838ad3776e42d459296d631950eb7ee3cac29b76b652af1944c1744974f"
    sha256 cellar: :any_skip_relocation, ventura:        "a97f0162b8fb99acc0c5bd4f5a2750c58ea6d28cba3befe5168cb3deef211c2f"
    sha256 cellar: :any_skip_relocation, monterey:       "56619db93a15222acd702b85af15b2bce56110df562860c39f12f328a4e3ff27"
    sha256                               x86_64_linux:   "c9af55e59926c616850f5bf7b2fa02ff09aeef281cbcbc333a5eab8d26f6b30e"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  on_macos do
    depends_on "make" => :build
    depends_on "qemu"
  end

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "protobuf" => :build
    depends_on "rust" => :build
    depends_on "conmon"
    depends_on "crun"
    depends_on "fuse-overlayfs"
    depends_on "gpgme"
    depends_on "libseccomp"
    depends_on "slirp4netns"
    depends_on "systemd"
  end

  resource "gvproxy" do
    on_macos do
      url "https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.7.1.tar.gz"
      sha256 "cbc97a44b6ca8f6c427ac58e193aa39c28674e4f1d2af09b5a9e35d1d3bb7fd3"
    end
  end

  resource "catatonit" do
    on_linux do
      url "https://github.com/openSUSE/catatonit/archive/refs/tags/v0.2.0.tar.gz"
      sha256 "d0cf1feffdc89c9fb52af20fc10127887a408bbd99e0424558d182b310a3dc92"
    end
  end

  resource "netavark" do
    on_linux do
      url "https://github.com/containers/netavark/archive/refs/tags/v1.8.0.tar.gz"
      sha256 "b1422ef6927458e9f80f7d322b751e29ab5d04d8ed6cb065baa82fa4291af10f"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https://github.com/containers/aardvark-dns/archive/refs/tags/v1.8.0.tar.gz"
      sha256 "c9b818110e3d5d45f8bdb3c9ccc48c994aedb0b19fefcc7577fc1ef7ed294343"
    end
  end

  def install
    if OS.mac?
      ENV["CGO_ENABLED"] = "1"

      system "gmake", "podman-remote"
      bin.install "bin/darwin/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"

      system "gmake", "podman-mac-helper"
      bin.install "bin/darwin/podman-mac-helper" => "podman-mac-helper"

      resource("gvproxy").stage do
        system "gmake", "gvproxy"
        (libexec/"podman").install "bin/gvproxy"
      end

      system "gmake", "podman-remote-darwin-docs"
      man1.install Dir["docs/build/remote/darwin/*.1"]

      bash_completion.install "completions/bash/podman"
      zsh_completion.install "completions/zsh/_podman"
      fish_completion.install "completions/fish/podman.fish"
    else
      paths = Dir["**/*.go"].select do |file|
        (buildpath/file).read.lines.grep(%r{/etc/containers/}).any?
      end
      inreplace paths, "/etc/containers/", etc/"containers/"

      ENV.O0
      ENV["PREFIX"] = prefix
      ENV["HELPER_BINARIES_DIR"] = opt_libexec/"podman"

      system "make"
      system "make", "install", "install.completions"

      (prefix/"etc/containers/policy.json").write <<~EOS
        {"default":[{"type":"insecureAcceptAnything"}]}
      EOS

      (prefix/"etc/containers/storage.conf").write <<~EOS
        [storage]
        driver="overlay"
      EOS

      (prefix/"etc/containers/registries.conf").write <<~EOS
        unqualified-search-registries=["docker.io"]
      EOS

      resource("catatonit").stage do
        system "./autogen.sh"
        system "./configure"
        system "make"
        mv "catatonit", libexec/"podman/"
      end

      resource("netavark").stage do
        system "make"
        mv "bin/netavark", libexec/"podman/"
      end

      resource("aardvark-dns").stage do
        system "make"
        mv "bin/aardvark-dns", libexec/"podman/"
      end
    end
  end

  def caveats
    on_linux do
      <<~EOS
        You need "newuidmap" and "newgidmap" binaries installed system-wide
        for rootless containers to work properly.
      EOS
    end
    on_macos do
      <<-EOS
        In order to run containers locally, podman depends on a Linux kernel.
        One can be started manually using `podman machine` from this package.
        To start a podman VM automatically at login, also install the cask
        "podman-desktop".
      EOS
    end
  end

  service do
    run linux: [opt_bin/"podman", "system", "service", "--time=0"]
    environment_variables PATH: std_service_path_env
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "podman-remote version #{version}", shell_output("#{bin}/podman-remote -v")
    out = shell_output("#{bin}/podman-remote info 2>&1", 125)
    assert_match "Cannot connect to Podman", out

    if OS.mac?
      out = shell_output("#{bin}/podman-remote machine init --image-path fake-testi123 fake-testvm 2>&1", 125)
      assert_match "Error: open fake-testi123: no such file or directory", out
    else
      assert_equal %W[
        #{bin}/podman
        #{bin}/podman-remote
        #{bin}/podmansh
      ].sort, Dir[bin/"*"].sort
      assert_equal %W[
        #{libexec}/podman/catatonit
        #{libexec}/podman/netavark
        #{libexec}/podman/aardvark-dns
        #{libexec}/podman/quadlet
        #{libexec}/podman/rootlessport
      ].sort, Dir[libexec/"podman/*"].sort
      out = shell_output("file #{libexec}/podman/catatonit")
      assert_match "statically linked", out
    end
  end
end
