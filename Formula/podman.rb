class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman.git",
      tag:      "v4.5.0",
      revision: "75e3c12579d391b81d871fd1cded6cf0d043550a"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7116c6e2c34207c67b98a7a6196bb037709591b0e99517a4073484bdc9b5ef1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0790437d459ced451898744154a469756d2dfccf1834357292766fb370d2a435"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "948c651dc096b35b61f032ea5a76ebb88f434f71e28e318cc712fcc2fe267059"
    sha256 cellar: :any_skip_relocation, ventura:        "5dea6e2fca0428a750ac1778b30ead93ae80e7457be032bca791e735418228fd"
    sha256 cellar: :any_skip_relocation, monterey:       "fe71fa878de5f9e2a6c739dbd090e73468e8f357165aea57576f3c1aac68b08d"
    sha256 cellar: :any_skip_relocation, big_sur:        "58c693652938b21dc4d35235dd762d24a14021b44b32277a9d4c46e430f27061"
    sha256                               x86_64_linux:   "34d09d1ddec838e4640f135ead490f945b1cfdb8ea161e880e02eace53d92bc8"
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
      url "https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.6.1.tar.gz"
      sha256 "3be16fd732724f7b65f3629cdc4cdad3e069b3f137f9a1c4bb40105082bc5740"
    end
  end

  resource "catatonit" do
    on_linux do
      url "https://github.com/openSUSE/catatonit/archive/refs/tags/v0.1.7.tar.gz"
      sha256 "e22bc72ebc23762dad8f5d2ed9d5ab1aaad567bdd54422f1d1da775277a93296"

      # Fix autogen.sh. Delete on next catatonit release.
      patch do
        url "https://github.com/openSUSE/catatonit/commit/99bb9048f532257f3a2c3856cfa19fe957ab6cec.patch?full_index=1"
        sha256 "cc0828569e930ae648e53b647a7d779b1363bbb9dcbd8852eb1cd02279cdbe6c"
      end
    end
  end

  resource "netavark" do
    on_linux do
      url "https://github.com/containers/netavark/archive/refs/tags/v1.6.0.tar.gz"
      sha256 "3bec9e9b0f3f8f857370900010fb2125ead462d43998ad8f43e4387a5b06f9d6"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https://github.com/containers/aardvark-dns/archive/refs/tags/v1.6.0.tar.gz"
      sha256 "f3a2ff2d7baf07d8bf2785b6f1c9618db8aa188bd738b7f5cf1b0a31848232f5"
    end
  end

  def install
    if OS.mac?
      ENV["CGO_ENABLED"] = "1"
      ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"

      system "make", "podman-remote"
      bin.install "bin/darwin/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"

      system "make", "podman-mac-helper"
      bin.install "bin/darwin/podman-mac-helper" => "podman-mac-helper"

      resource("gvproxy").stage do
        system "make", "gvproxy"
        (libexec/"podman").install "bin/gvproxy"
      end

      system "make", "podman-remote-darwin-docs"
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
