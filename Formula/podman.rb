class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v4.3.1.tar.gz"
  sha256 "455c29c4ee78cd6365e5d46e20dd31a5ce4e6e1752db6774253d76bd3ca78813"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f65eb8652f1ee79a37bcc3c7d9d75719c13d7aa3b2b925d389ee2689451a7d40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28a80ebdbe1122e9a8a80ce181e06080283624b5f0a90fb29e560c930eacd078"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d010a00b1043cf2ffebac0f0c66f8c63ff73cebceebd9f4a1cc8e63adffa47bf"
    sha256 cellar: :any_skip_relocation, ventura:        "ecb89c93c4c0553d0266d9e728d1d4957f9d7ad0df42fd2f3598a3d2b0321286"
    sha256 cellar: :any_skip_relocation, monterey:       "de397cb09c3df316b361c8dec36f5a97c1d368d7c5edc29e457c2f1d93af98a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a82273855cecb6551f7c015291b1bf28b782729279693f22227163c0142b0b0"
    sha256 cellar: :any_skip_relocation, catalina:       "bbf973e605e9bf56837448ddd956e566900177cd4aa339c15911eb34ae16832a"
    sha256                               x86_64_linux:   "4b4d3245f41cc8ad7f6352f1ccd8db1ad5a12910572ef47a6a1ec1d053aec5dd"
  end

  depends_on "go-md2man" => :build
  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  on_macos do
    depends_on "qemu"
  end

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "pkg-config" => :build
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
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.4.0.tar.gz"
      sha256 "896cf02fbabce9583a1bba21e2b384015c0104d634a73a16d2f44552cf84d972"
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
      url "https://github.com/containers/netavark/archive/refs/tags/v1.3.0.tar.gz"
      sha256 "cc8a8e03498cb9b4c74fdbda09a64fdf9000fea398d07073c4e368fc83d35f56"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https://github.com/containers/aardvark-dns/archive/refs/tags/v1.3.0.tar.gz"
      sha256 "6dd1ce4346ed5c57bbd990140e02e69c036919032582b937d2ad7835329d3bc3"
    end
  end

  def install
    if OS.mac?
      ENV["CGO_ENABLED"] = "1"

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
        system "cargo", "install", *std_cargo_args
        mv bin/"netavark", libexec/"podman/"
      end

      resource("aardvark-dns").stage do
        system "cargo", "install", *std_cargo_args
        mv bin/"aardvark-dns", libexec/"podman/"
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
  end

  service do
    run [opt_bin/"podman", "system", "service", "--time=0"]
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
        #{libexec}/podman/rootlessport
      ].sort, Dir[libexec/"podman/*"].sort
      out = shell_output("file #{libexec}/podman/catatonit")
      assert_match "statically linked", out
    end
  end
end
