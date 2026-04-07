class Ix < Formula
  desc "Persistent memory CLI for LLM systems"
  homepage "https://github.com/ix-infrastructure/Ix"
  url "https://github.com/ix-infrastructure/Ix/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "4f300a42b22cdd6f7e6e600a7741e5a7ec6fb6df399323b079a190d942d34704"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "node@22"
  depends_on "ripgrep"

  on_linux do
    depends_on "patchelf" => :build
  end

  def install
    cd "core-ingestion" do
      # --omit=optional excludes tree-sitter-swift/kotlin which require
      # tree-sitter-cli to compile and are loaded via tryLoadGrammar at runtime.
      system "npm", "install", *std_npm_args(prefix: false), "--omit=optional"

      if OS.linux?
        # Bundled prebuilds are musl-compiled (Alpine CI) and ABI-incompatible
        # with Homebrew's glibc. Delete them so node-gyp-build (the install
        # script) falls through to node-gyp rebuild, producing glibc binaries.
        rm_r(Dir["node_modules/**/prebuilds"])
        system "npm", "rebuild"
      end

      system "npm", "run", "build"
    end

    if OS.mac?
      # Remove non-native tree-sitter prebuilds by folder name
      native_prebuild = Hardware::CPU.arm? ? "darwin-arm64" : "darwin-x64"
      Dir["core-ingestion/node_modules/**/prebuilds/*"].each do |dir|
        rm_r(dir) if File.basename(dir) != native_prebuild
      end

      # Verify remaining .node files match the native architecture
      native_arch = Hardware::CPU.arm? ? "aarch64" : "x86-64"
      Dir["core-ingestion/node_modules/**/prebuilds/**/*.node"].each do |f|
        file_info = `file -b #{f}`.strip
        next if file_info.include?(native_arch)
        next if file_info.include?("universal")

        rm(f)
      end
    end

    (libexec/"core-ingestion").install Dir["core-ingestion/dist",
                                          "core-ingestion/node_modules",
                                          "core-ingestion/package.json"]

    cd "ix-cli" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "version", version.to_s, "--no-git-tag-version", "--allow-same-version"
      system "npx", "tsc"
      libexec.install "dist", "node_modules", "package.json"
    end

    if OS.mac?
      # Thin universal .node binaries (e.g. fsevents) to native arch only
      native_cpu = Hardware::CPU.arm? ? :arm64 : :x86_64
      Dir[libexec/"**/*.node"].each do |f|
        macho = MachO.open(f)
        next unless macho.is_a?(MachO::FatFile)

        native_slice = macho.machos.find { |m| m.cputype == native_cpu }
        next unless native_slice

        native_slice.write(f)
      end
    else
      # Fix unversioned libc.so reference from node-gyp compiled modules
      Dir[libexec/"**/*.node"].each do |f|
        system "patchelf", "--replace-needed", "libc.so", "libc.so.6", f
      end
    end

    chmod 0755, libexec/"dist/cli/main.js"

    node_path = Formula["node@22"].opt_bin
    rg_path = Formula["ripgrep"].opt_bin

    (bin/"ix").write_env_script libexec/"dist/cli/main.js",
      PATH: "#{node_path}:#{rg_path}:$PATH"
  end

  def caveats
    <<~EOS
      The ix CLI is installed. To start the backend:

        ix docker start

      This requires Docker Desktop to be running.
      The backend runs as two containers: ArangoDB + Memory Layer.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ix --version")
    output = `#{bin}/ix status 2>&1`
    assert_match(/Ix|Memory|backend/i, output)
  end
end
