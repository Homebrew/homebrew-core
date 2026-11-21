class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.57.1.tar.gz"
  sha256 "86999c82ca6e358a75e390fa6bd08849e66db39e7145873c4c167ac38476340f"
  license "MIT"

  bottle do
    manifest_sha256 "b1127a4c905bcb5d9204c459af50ba41a8f1cff212f23abbfbcfc798be105597"
    sha256 arm64_golden_gate: "837e93200c5790397ee1373f95c27a11467a66958fe52df249340ab1fae0c053"
    sha256 arm64_tahoe:       "2aab9da80fb100bb8a286d48e8fd7961aa44c2af327085a888573bdbe09747aa"
    sha256 arm64_sequoia:     "668668fce21b58a8e992667b55f1c654b8d3128cd7136b0c0509b74023fcf6d1"
    sha256 arm64_linux:       "4f643b98d0451d807035ba1735c74bd923551c87ae52efc9e7f159f8d93479fc"
    sha256 x86_64_linux:      "2b95525a542becc3c2cf90ab3d6723b0f1c81be6616b92c5f3e8413a928f65e8"
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
