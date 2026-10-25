class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.55.3.tar.gz"
  sha256 "d61d27116a36e01ce368d014a2717c792cb592d4aee6081e265cd8d543ce3b2d"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "379e61ef6d1685ee3a156288e722cfa5d0b5ed5227f17b3309a1ddd3c16f66b3"
    sha256 arm64_tahoe:       "efcc0099a4d569689721a15e5039fad6a2fd15a652f0fd389bc78c09ea1b6e69"
    sha256 arm64_sequoia:     "cbe9e53ceecd634b6bed34b93fb730b21c9f1e35f85b2379101d1fc1e5fad533"
    sha256 arm64_linux:       "6268dbc946862a3bf6c38691c6047e4580bd73f86f265511f7976f02335e18ba"
    sha256 x86_64_linux:      "528dd644d0831c20029b8013988a2b7678b5305892db666eba645d18121fa575"
  end

  depends_on "bun" => :build

  on_linux do
    # `bun build --compile` embeds the runtime, so the output inherits bun's ICU linkage.
    depends_on "icu4c@79"
  end

  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula
      icu = deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

    # Upstream injects the version at release time; the tagged `package.json` lags.
    ENV["BACKLOG_BUILD_VERSION"] = version.to_s

    # Not `bun run build`: that resolves `bun` from `node_modules/.bin`, and
    # `bun build --compile` embeds whichever runtime ran the build.
    system "bun", "scripts/build.ts"

    bin.install "dist/backlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
