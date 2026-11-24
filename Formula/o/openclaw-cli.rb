class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.11.7.tgz"
  sha256 "6ade4b82af1c0654be38d73566cf163037a0c05bcb2ef63772905ac38a1dd1c1"
  license "MIT"

  bottle do
    manifest_sha256 "4fdf6f08c82010aab8acfdf494c27fef9689d4d4e9d708661304185f0343b8e2"
    sha256               arm64_golden_gate: "f04ffe38884efeabff0c379f090f87d18053a05333cd7c69e1b44c1ad512843e"
    sha256               arm64_tahoe:       "f04ffe38884efeabff0c379f090f87d18053a05333cd7c69e1b44c1ad512843e"
    sha256               arm64_sequoia:     "f04ffe38884efeabff0c379f090f87d18053a05333cd7c69e1b44c1ad512843e"
    sha256 cellar: :any, arm64_linux:       "e97cea5030c63685027a6b66886454780bad86b82b5a0d3845fae017adce9f3d"
    sha256 cellar: :any, x86_64_linux:      "94a95e370e477946bdc2b1c03002f41060aad664a82418ae778dd4ea3ef8bd68"
  end

  depends_on "node"

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # `--ignore-scripts` leaves a marker that makes the launcher write into the read-only keg
    system "node", libexec/"lib/node_modules/openclaw/scripts/postinstall-bundled-plugins.mjs"

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"

    # sqlite-vec falls back cleanly when the native extension is unavailable.
    # Remove macOS pre-built dylibs that fail Homebrew bottle linkage fixups.
    node_modules.glob("sqlite-vec-darwin-*").each { |dir| rm_r(dir) } if OS.mac?

    # Remove incompatible pre-built binaries (non-native architectures
    # and GPU variants requiring CUDA/Vulkan)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    platform = OS.linux? ? "linux" : "mac"
    target = "#{platform}-#{arch}"

    node_modules.glob("tree-sitter-bash/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != target
    end

    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?(target) &&
              basename.exclude?("cuda") &&
              basename.exclude?("vulkan")

      rm_r(dir)
    end

    os = OS.kernel_name.downcase
    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end

    # Rebuild the X11 clipboard helper against our `libxcb`
    system "bash", node_modules/"@earendil-works/pi-tui/native/linux/build.sh" if OS.linux?

    # koffi binaries moved to `@koromix/koffi-*`, which also ships a musl build
    node_modules.glob("@koromix/koffi-*/*").each do |dir|
      rm_r(dir) if dir.directory? && dir.basename.to_s != "#{os}_#{arch}"
    end

    # Unusable prebuilt: patching it for X11 rpaths or thinning the fat Mach-O breaks its pinned digest
    node_modules.glob("@trycua/cua-driver-*").each { |dir| rm_r(dir) }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end
