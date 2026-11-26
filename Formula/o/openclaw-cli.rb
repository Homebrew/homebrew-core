class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.11.10.tgz"
  sha256 "19c923bc781ea06de56888b2a4690967aaa641a4832d1f2112b3f779870cfc30"
  license "MIT"

  bottle do
    manifest_sha256 "3413ebdad3dfe3fd2152d9a9125a8e2f18aaa7b8819a30db987a1f4053bb4742"
    sha256               arm64_golden_gate: "99bb890fa248839cd11d69fd3e85fc9a86b40bbfc475ec0dc59ddb00b4366dca"
    sha256               arm64_tahoe:       "99bb890fa248839cd11d69fd3e85fc9a86b40bbfc475ec0dc59ddb00b4366dca"
    sha256               arm64_sequoia:     "99bb890fa248839cd11d69fd3e85fc9a86b40bbfc475ec0dc59ddb00b4366dca"
    sha256 cellar: :any, arm64_linux:       "f8dc20b8a9f915543ab4d449ff2755b51dedcdd99b33028dc98860b5dbbd0ab6"
    sha256 cellar: :any, x86_64_linux:      "a13e385a57e3c900c30e01c0498ee12b7f73f761857ed045c337e5ba74535a0d"
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
