class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  url "https://github.com/kdlbs/kandev/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "048f581049a008d8232df87dc0c3999ba2739c3e99bdfa99bd69acef9d68af64"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go"   => :build
  depends_on "pnpm" => :build
  depends_on "node"

  uses_from_macos "rsync" => :build
  uses_from_macos "sqlite"

  def install
    ENV["KANDEV_VERSION"] = version.to_s

    system "pnpm", "-C", "apps", "install", "--frozen-lockfile"
    system "pnpm", "-C", "apps", "--filter", "@kandev/web", "build"
    system "./scripts/release/package-web.sh"
    system "./scripts/release/package-cli.sh"

    bundle = buildpath/"dist/kandev"
    (bundle/"bin").mkpath

    cd "apps/backend" do
      # kandev backend needs cgo for mattn/go-sqlite3.
      with_env(CGO_ENABLED: "1") do
        system "go", "build",
               *std_go_args(ldflags: "-s -w -X main.Version=#{version}",
                            output:  bundle/"bin/kandev"),
               "./cmd/kandev"
      end
      # agentctl is pure-Go; build it static to avoid a dynamic linker
      # crash observed on Linuxbrew arm64 bottle CI.
      with_env(CGO_ENABLED: "0") do
        system "go", "build",
               *std_go_args(ldflags: "-s -w", output: bundle/"bin/agentctl"),
               "./cmd/agentctl"
      end
    end

    system "./scripts/release/package-bundle.sh"

    # The Next.js standalone tracer pulls platform-tagged native modules
    # into the bundle, including musl-libc variants of sharp, @swc/core,
    # and lightningcss that brew linkage --test flags on glibc-only
    # Linuxbrew. Strip them — rm_r handles both directory trees (the
    # current shape) and bare .node files (in case a future bundler
    # version inlines them). The exist? guard handles the glob
    # returning a parent dir and its musl-named children together —
    # removing the parent makes the child paths vanish before we get
    # to them.
    bundle.glob("web/**/*musl*").each { |p| rm_r(p) if p.exist? }

    libexec.install Dir[bundle/"*"]

    (bin/"kandev").write_env_script libexec/"cli/bin/cli.js",
      KANDEV_BUNDLE_DIR: libexec.to_s,
      KANDEV_VERSION:    version.to_s
  end

  test do
    # Wrapper sanity: confirms write_env_script wired KANDEV_BUNDLE_DIR
    # and the launcher reads the bundled package.json version.
    assert_match version.to_s, shell_output("#{bin}/kandev --version")

    # Functional test: exercise the agentctl sidecar's CLI subcommand
    # dispatcher. Boots the Go binary, parses flags, dispatches to the
    # kandev subcommand handler, and prints usage when called without
    # arguments. Verifies the binary loads correctly across platforms
    # without requiring HTTP listeners, port binds, or subprocesses —
    # which can be problematic in sandboxed build environments.
    output = shell_output("#{libexec}/bin/agentctl kandev 2>&1", 1)
    assert_match "Usage: agentctl kandev", output
  end
end
