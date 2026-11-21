class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "e37248e09b4c179de9e4036806a52dcdd18e8cb7b459156ee8bfd174081e55b7"
  license "MIT"

  bottle do
    manifest_sha256 "bd3c739c8bc17a8a21b6dec614186ba20ef8b9afc4ac3abce2220f175d2f2bd5"
    sha256 arm64_golden_gate: "106ea0abe84ed4abb3ea11378bdd8c4a716d4858b310e46ad52ca456d36a7779"
    sha256 arm64_tahoe:       "d8acedcfc32193218d6b0a503bb1b66e9443dfa9c4b477ee747528794f7b1c54"
    sha256 arm64_sequoia:     "3c4f60dc436018fadc7620e44a650e5a5d7ca27c9f8c8c3aff9e675d0a12303c"
    sha256 arm64_linux:       "5438941651ec9aa8c5a4268addd6da0dd202b4732be0d8daf942e38e284708db"
    sha256 x86_64_linux:      "217280c29d81c3e99dac4eb26714a5464ec38cb993734b8d26b6519c87f21115"
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
