class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.57.4.tar.gz"
  sha256 "cdbbf444445f63a4cd2fe9a3e815269e80d71d218f9ea80474afc01a9de61cb5"
  license "MIT"

  bottle do
    manifest_sha256 "ae015aa9c8ce692240d527815626decfc15125484de901b1b3c7e682a3eab74a"
    sha256 arm64_golden_gate: "eb8080ecd5ae24f46d0b00ea3eee3c16b62da2cabaf6e66d0958649fd9feb9dd"
    sha256 arm64_tahoe:       "8d9e28aaf061fbb86c476c44a518002fe11c1a39fb914671a8a19942e5abed6b"
    sha256 arm64_sequoia:     "a23c0711d06c7190016be2bbca4072ce05d94d4804ebcafa976fd0e898bd0b1f"
    sha256 arm64_linux:       "eb11a7e45b5419d1bd9d0cb47cb21e60a83f2fe8040bd4a303c85c823a6cfb06"
    sha256 x86_64_linux:      "ec9a4cfebd0703433c63033c1d0a960b55222f199780b80dbf8d843dffc51c3d"
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
      bun_icu = Formula["bun"].dep("icu4c").to_formula
      icu = dep("icu4c").to_formula

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
