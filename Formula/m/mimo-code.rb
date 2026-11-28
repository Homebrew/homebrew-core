class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://github.com/XiaomiMiMo/MiMo-Code/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "25256c3174b71191e33a5bf28f80faa21f16dcc8f0b3d8ba041f83b5f0101a81"
  license "MIT"

  bottle do
    manifest_sha256 "b144e4a337788e37289cf24cb70221f07788c10bb05fbe9af71e0416e9c90fd3"
    sha256 arm64_golden_gate: "864fd2b4ea40c65e5aba955f3f110c9e68b6be93c55fd9ffeb2156538cf2ee64"
    sha256 arm64_tahoe:       "b7993219d1523099870c0e679caa2846d5f1db871174d17c356725b78a96c189"
    sha256 arm64_sequoia:     "a943d7f21491ad241ae18a884d04bd041e0deccfafaf7fd9ea1ccbac062567f3"
    sha256 arm64_linux:       "52ccd8f62f29790d7367e3172e7cd51945527503f807014d780719004b2fefd6"
    sha256 x86_64_linux:      "c3122783c541a20d488e4f54d47ca838268fb2c8adaebf1de1e3cfbdfb648e8b"
  end

  depends_on "bun" => :build
  depends_on "ripgrep"

  uses_from_macos "python" => :build # for node-gyp

  on_linux do
    depends_on "icu4c@79"
  end

  def install
    ENV["MIMOCODE_VERSION"] = version.to_s
    ENV["MIMOCODE_CHANNEL"] = "latest"

    # The build refuses any Bun other than the exact `packageManager` pin, so pin the brewed one
    bun_version = Formula["bun"].version
    inreplace "package.json", /"packageManager": "bun@[\d.]+"/, "\"packageManager\": \"bun@#{bun_version}\""

    system "bun", "install", "--frozen-lockfile"

    cd "packages/cli" do
      system "bun", "--bun", "./script/build.ts", "--single", "--skip-install"
      bin.install Pathname.pwd.glob("dist/mimocode-*/bin/mimo").first
    end
  end

  test do
    ENV["MIMOCODE_DISABLE_AUTOUPDATE"] = "1"
    ENV["MIMOCODE_DISABLE_MODELS_FETCH"] = "1"

    assert_match version.to_s, shell_output("#{bin}/mimo --version")
    assert_match "mimo", shell_output("#{bin}/mimo models")
  end
end
