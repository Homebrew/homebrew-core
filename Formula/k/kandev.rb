class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://kandev.ai"
  url "https://github.com/kdlbs/kandev/archive/refs/tags/v0.86.1.tar.gz"
  sha256 "dd7dff4c8af3f407d29fa5e523f99ea3c48d417d9d1e76ceaf2cc1ff320d9333"
  license "AGPL-3.0-only"
  head "https://github.com/kdlbs/kandev.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build
  depends_on "node@24" => :build
  depends_on "pnpm@10" => :build

  def install
    inreplace "apps/pnpm-workspace.yaml", "packages:", "managePackageManagerVersions: false\n\npackages:"
    system "pnpm", "--dir", "apps", "install", "--frozen-lockfile"

    bundle = buildpath/"dist/homebrew"
    system "make", "runtime-bundle",
           "GOFLAGS=-trimpath",
           "PNPM=pnpm",
           "RUNTIME_BUNDLE_DIR=#{bundle}",
           "RUNTIME_VERSION=#{version}"
    libexec.install bundle.children

    (bin/"kandev").write_env_script libexec/"bin/kandev",
      KANDEV_BUNDLE_DIR: libexec.to_s,
      KANDEV_VERSION:    version.to_s
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/kandev --version").strip

    ENV["KANDEV_HOME_DIR"] = testpath.to_s
    ENV["KANDEV_DATABASE_PATH"] = (testpath/"kandev.db").to_s
    ENV["KANDEV_SERVER_HOST"] = "127.0.0.1"
    port = free_port
    pid = spawn bin/"kandev", "--headless", "--port", port.to_s
    curl = "curl --silent --show-error --fail --retry 30 --retry-connrefused --retry-delay 1"
    health = shell_output("#{curl} http://127.0.0.1:#{port}/health")
    assert_match '"status":"ok"', health
    assert_match "<title>Kandev</title>", shell_output("#{curl} http://127.0.0.1:#{port}/")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
