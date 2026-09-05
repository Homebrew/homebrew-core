class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.9.1.tgz"
  sha256 "1bfcac877d53f1e41b69d15c24e081895b2f07d6ff2ffdfe0bf8a7336ab00e59"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "34be8003a271e8813b2087b52e6fd34730637fc2186c14127636cdc44703815f"
    sha256                               arm64_sequoia: "34be8003a271e8813b2087b52e6fd34730637fc2186c14127636cdc44703815f"
    sha256                               arm64_sonoma:  "34be8003a271e8813b2087b52e6fd34730637fc2186c14127636cdc44703815f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "555f3b996d6cb9f60e2ad0bac823b07c9e56046b1505307ed2388029e0d147fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eff8373738efde12d67a501083cc1f8de5424de6bac6f79fb7023635a8a7393d"
  end

  depends_on "node"

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
    target = "#{OS.linux? ? "linux" : "mac"}-#{arch}"

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
