class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "9f325ac263114ac43f73081cbd874e2e7d43855a3c41cd2e44e8434ab0379012"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "4ab9828b9662492676892099d47843788fd837cd02df9939f6a92010370d7c57"
    sha256 arm64_tahoe:       "148eaef50c15632f98b949ebb3443f2e8a000fc90ce47412612b01328409cc64"
    sha256 arm64_sequoia:     "eab5c36ea01bc325eea0facdd4d01ea0ad88dbaecb596cf17c2e5fa6a907d040"
    sha256 arm64_linux:       "ab39b586e6d31d843e1a80113c1292785a97cb0d320ed6b2dde2a093a7baa3c0"
    sha256 x86_64_linux:      "b345a4e822da2c2aadda8e25f9e7ad6575d8edb2c716428143a95e6fc879acf1"
  end

  depends_on "bun" => :build

  on_linux do
    # `bun build --compile` embeds the runtime, so the output inherits bun's ICU linkage.
    depends_on "icu4c@78"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula
      icu = deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"

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
