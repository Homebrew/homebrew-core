class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/podman-container-tools/podman/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "10a56f6a36c4f7ea19956d7298615a6ff1f46978fc36d31dfe31be14899d10fb"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  compatibility_version 1
  head "https://github.com/podman-container-tools/podman.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created and upstream uses GitHub releases to
  # indicate when a version is released, so we check the "latest" release
  # instead of the Git tags. Maintainers confirmed:
  # https://github.com/Homebrew/homebrew-core/pull/205162#issuecomment-2607793814
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "4452f6a3bf6038e1391e0fcf5902fed036c9ae71a6fe41d313f719d4b432c5e4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22ab404742f777abfe41c9e88d2dad222cb5bb5adf23deeff1b061ce813a81e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ebd9073c77cb8833fc88999c0a6bfc39e583bdc2058b64996ddd44d22e25c7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "778e336a5a8131398ea3120cf1152607b6e97850ed4a3d2598e16ca7bcb70854"
    sha256                               arm64_linux:       "129f6a008433f53c3864c4a51b84dfbb26f089cb1448fba1ee298a8832c2ebf7"
    sha256                               x86_64_linux:      "2d2ca628f8761c42a77077e19e6cac09d8b88ba83115fa7b80b835127e88dddd"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "make" => :build
    depends_on arch: :arm64
    depends_on "krunkit" => :no_linkage
    depends_on macos: :ventura # see discussions in https://github.com/containers/podman/issues/22121
  end

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
    depends_on "protobuf" => :build
    depends_on "rust" => :build
    depends_on "conmon"
    depends_on "crun"
    depends_on "fuse-overlayfs"
    depends_on "gpgme"
    depends_on "libseccomp"
    depends_on "passt"
    depends_on "sqlite"
    depends_on "systemd"
  end

  # Match the macOS helpers to go.mod and contrib/pkginstaller/Makefile at the release tag.
  #
  # More context: https://github.com/Homebrew/homebrew-core/pull/205303
  resource "gvproxy" do
    on_macos do
      url "https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.9.0.tar.gz"
      sha256 "b83e6049623845f626aa09720ba162e630188f3a5d539d5a773457bc5ab61023"

      livecheck do
        url "https://raw.githubusercontent.com/podman-container-tools/podman/refs/tags/v#{LATEST_VERSION}/go.mod"
        regex(%r{github\.com/containers/gvisor-tap-vsock\s+v?(\d+(?:\.\d+)+)}i)
      end
    end
  end

  resource "vfkit" do
    on_macos do
      url "https://github.com/crc-org/vfkit/archive/refs/tags/v0.6.4.tar.gz"
      sha256 "ff496bd6ee6772ed070f286c4282a8a2e2f5231d4f8e98b2255b883ba69af42d"

      livecheck do
        url "https://raw.githubusercontent.com/podman-container-tools/podman/refs/tags/v#{LATEST_VERSION}/contrib/pkginstaller/Makefile"
        regex(/^VFKIT_VERSION\s*\?=\s*v?(\d+(?:\.\d+)+)/i)
      end
    end
  end

  resource "catatonit" do
    on_linux do
      url "https://github.com/openSUSE/catatonit/archive/refs/tags/v0.2.1.tar.gz"
      sha256 "771385049516fdd561fbb9164eddf376075c4c7de3900a8b18654660172748f1"

      livecheck do
        url :url
        regex(/^v?(\d+(?:\.\d+)+)$/i)
      end
    end
  end

  resource "netavark" do
    on_linux do
      url "https://github.com/containers/netavark/archive/refs/tags/v2.1.0.tar.gz"
      sha256 "96677048168ddd1abe313e4c2e17f1cace72b60ee1bac8ca12a4bd7dfcadfbbb"

      livecheck do
        url :url
        regex(/^v?(\d+(?:\.\d+)+)$/i)
      end
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https://github.com/containers/aardvark-dns/archive/refs/tags/v2.1.0.tar.gz"
      sha256 "daf871488603e659b0501224cf0731ac317809b1d1701fc061cb4f6ae39a894f"

      livecheck do
        url :url
        regex(/^v?(\d+(?:\.\d+)+)$/i)
      end
    end
  end

  # `test do` block needs local sockets for machine setup
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    if OS.mac?
      resource("gvproxy").stage do
        system "go", "mod", "download"
      end
      resource("vfkit").stage do
        system "go", "mod", "download"
      end
    else
      resource("netavark").stage do
        system "cargo", "fetch", *std_cargo_fetch_args
      end
      resource("aardvark-dns").stage do
        system "cargo", "fetch", *std_cargo_fetch_args
      end
    end
  end

  def install
    if OS.mac?
      ENV["CGO_ENABLED"] = "1"
      ENV["BUILD_ORIGIN"] = "brew"

      system "gmake", "podman-remote"
      bin.install "bin/darwin/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"

      system "gmake", "podman-mac-helper"
      bin.install "bin/darwin/podman-mac-helper"

      resource("gvproxy").stage do
        system "gmake", "gvproxy"
        (libexec/"podman").install "bin/gvproxy"
      end

      resource("vfkit").stage do
        ENV["CGO_ENABLED"] = "1"
        ENV["CGO_CFLAGS"] = "-mmacosx-version-min=11.0"
        ENV["GOOS"]="darwin"
        arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
        system "gmake", "out/vfkit-#{arch}"
        (libexec/"podman").install "out/vfkit-#{arch}" => "vfkit"
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
      ENV["BUILD_ORIGIN"] = "brew"

      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arm64?
        ENV["CGO_ENABLED"] = "1"
        ENV["GO_EXTLINK_ENABLED"] = "1"
        ENV.append "GOFLAGS", "-buildmode=pie -trimpath"
      end

      system "make"
      system "make", "install", "install.completions"

      (prefix/"etc/containers/policy.json").write <<~JSON
        {"default":[{"type":"insecureAcceptAnything"}]}
      JSON

      (prefix/"etc/containers/storage.conf").write <<~CONF
        [storage]
        driver="overlay"
      CONF

      (prefix/"etc/containers/registries.conf").write <<~CONF
        unqualified-search-registries=["docker.io"]
      CONF

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
      <<~EOS
        In order to run containers locally, podman depends on a Linux kernel.
        One can be started manually using `podman machine` from this package.
        To start a podman VM automatically at login, also install the cask
        "podman-desktop".
      EOS
    end
  end

  service do
    run linux: [opt_bin/"podman", "system", "service", "--time", "0"]
    environment_variables PATH: std_service_path_env
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "podman-remote version #{version}", shell_output("#{bin}/podman-remote -v")
    out = shell_output("#{bin}/podman-remote info 2>&1", 125)
    assert_match "Cannot connect to Podman", out

    if OS.mac?
      # This test will fail if VM images are not built yet. Re-run after VM images are built if this is the case
      # See https://github.com/Homebrew/homebrew-core/pull/166471
      out = shell_output("#{bin}/podman-remote machine init homebrew-testvm")
      assert_match "Machine init complete", out

      system bin/"podman-remote", "machine", "rm", "-f", "homebrew-testvm"
    else
      assert_equal %w[podman podman-remote podmansh]
        .map { |binary| File.join(bin, binary) }.sort, Dir[bin/"*"]
      assert_equal %W[
        #{libexec}/podman/catatonit
        #{libexec}/podman/netavark
        #{libexec}/podman/aardvark-dns
        #{libexec}/podman/quadlet
        #{libexec}/podman/rootlessport
      ].sort, Dir[libexec/"podman/*"]
      out = shell_output("file #{libexec}/podman/catatonit")
      assert_match "statically linked", out
    end
  end
end
