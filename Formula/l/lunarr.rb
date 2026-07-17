class Lunarr < Formula
  desc "Self-hosted media streaming server and Plex alternative for movies and TV"
  homepage "https://github.com/lunarr-app/lunarr-go"
  url "https://github.com/lunarr-app/lunarr-go/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "fff0092ad79270bd951692a8f32cb2ee6eb8a4d477ef2b4d6d1ba27752cf1c7e"
  license "Apache-2.0"
  head "https://github.com/lunarr-app/lunarr-go.git", branch: "main"

  depends_on "ffmpeg"
  depends_on "node"

  def install
    # Skip node-av's postinstall, which downloads a bundled FFmpeg binary from
    # GitHub; the formula already depends on the ffmpeg formula instead.
    system "npm", "install", *(std_npm_args(prefix: false, ignore_scripts: true) - ["--build-from-source"])
    system "npm", "run", "build"

    # Remove dev dependencies from the installed tree.
    system "npm", "prune", "--omit=dev"

    # fsevents (a dependency of chokidar) ships a universal Mach-O binary that
    # fails `brew audit`; strip the unused architecture slice instead of
    # removing it so chokidar keeps its native file watcher.
    deuniversalize_machos "node_modules/fsevents/fsevents.node" if OS.mac?

    # libsql and node-av ship prebuilt platform packages for every OS/arch via
    # optionalDependencies. Only the package matching the current platform is
    # needed at runtime, and the musl libsql build links an unversioned
    # `libc.so` that fails `brew linkage` on glibc CI. Drop the non-matching
    # and musl prebuilt directories from the build tree.
    Dir["node_modules/@libsql/*musl*"].each { |p| rm_r p }
    Dir["node_modules/@seydx/*"].each { |p| rm_r p } unless OS.mac?
    Dir["node_modules/@seydx/*linux*"].each { |p| rm_r p } if OS.mac?
    Dir["node_modules/@seydx/*darwin*"].each { |p| rm_r p } unless OS.mac?
    Dir["node_modules/@libsql/*arm64*"].each { |p| rm_r p } unless Hardware::CPU.arm?
    Dir["node_modules/@libsql/*x64*"].each { |p| rm_r p } if Hardware::CPU.arm?

    libexec.install Dir["*"]
    (bin/"lunarr").write <<~EOS
      #!/bin/sh
      export LUNARR_APP_VERSION="#{version}"
      export LUNARR_DATA_DIR="#{var}/lunarr"
      export NODE_ENV="production"
      export FFMPEG_PATH="#{formula_opt_bin("ffmpeg")}/ffmpeg"
      # Use a user-provided AUTH_SECRET if set; otherwise read (or generate on
      # first run) a stable session secret persisted in the data directory.
      if [ -z "$AUTH_SECRET" ]; then
        SECRET_FILE="#{var}/lunarr/.auth_secret"
        if [ ! -s "$SECRET_FILE" ]; then
          mkdir -p "#{var}/lunarr"
          head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n' > "$SECRET_FILE" 2>/dev/null
          chmod 600 "$SECRET_FILE" 2>/dev/null
        fi
        export AUTH_SECRET="$(cat "$SECRET_FILE" 2>/dev/null)"
      fi
      export ORIGIN="${ORIGIN:-http://localhost:3000}"
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/scripts/start.mjs" "$@"
    EOS
    chmod 0555, bin/"lunarr"
  end

  test do
    assert_path_exists libexec/"build/index.js"
    assert system formula_opt_bin("node")/"node", "--check", libexec/"build/index.js"
  end
end
