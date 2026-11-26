class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.11.9.tgz"
  sha256 "5bc8dd26057508ed4295c20ed42d7fd788f34fe1ff33cd7b6545a7e9239845a8"
  license "MIT"

  bottle do
    manifest_sha256 "b8735e64dea13d10a0e21a26d7b5f810658f3e45d0ac194204baea6df7d553d5"
    sha256               arm64_golden_gate: "b1c4a66f9fcc81619c94ef0baeece9c54494294f25d0e29269d3c76497f08978"
    sha256               arm64_tahoe:       "b1c4a66f9fcc81619c94ef0baeece9c54494294f25d0e29269d3c76497f08978"
    sha256               arm64_sequoia:     "b1c4a66f9fcc81619c94ef0baeece9c54494294f25d0e29269d3c76497f08978"
    sha256 cellar: :any, arm64_linux:       "baafc5d589a865ee418590417861d00d4a8a8bd14d42e2be5232489544ff8425"
    sha256 cellar: :any, x86_64_linux:      "9aa1e094050926f02a1f904df34037659db1e14d09b1a6021c4f418613770480"
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
