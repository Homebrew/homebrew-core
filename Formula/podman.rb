class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman.git",
      tag:      "v4.4.2",
      revision: "74afe26887f814d1c39925a1624851ef3590e79c"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab4807026c0d21ae9b98bff0358013af1b13c2fce99e6be2f158cc3b2953ff74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2f5b42a41ccac78911cc64fdb32c5aecf760d5d12090f7ae8a98d8bb2724744"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65cab4e0ce28d1903717ef4fa322c1c841d87131dc9f5fb0b71313e4a48b3124"
    sha256 cellar: :any_skip_relocation, ventura:        "489dfb06464fe6b0f6cb9019c1dce47ad02089ad079702acdf1255bd2db703d6"
    sha256 cellar: :any_skip_relocation, monterey:       "9b0f979ddc3b1a6a517517160cbfd8f62eeb9541cc88e52b8900dfe74aee72d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5788a48890a43f06265f7534d605733fc87e28182f1efb78107bfa1a3cbed2a9"
    sha256                               x86_64_linux:   "6128b273ce2149dfd2549edda00afa1f32c935b9980a891697d9d43892b2edab"
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
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.5.0.tar.gz"
      sha256 "8048f4f5faa2722547d1854110c2347f817b2f47ec51d39b2a7b308f52a7fe59"
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
      url "https://github.com/containers/netavark/archive/refs/tags/v1.5.0.tar.gz"
      sha256 "303fbcf3fc645b0e8e8fc1759626c92082f85f49b9d07672918aebd496a24d34"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https://github.com/containers/aardvark-dns/archive/refs/tags/v1.5.0.tar.gz"
      sha256 "b7e7ca1b94c1a62c8800f49befb803ec37cc5caf7656352537343a8fb654e4a6"
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

      # Remove the "-j1" flag at next release
      system "make", "-j1", "podman-remote-darwin-docs"
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
