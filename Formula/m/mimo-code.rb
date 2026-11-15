class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://github.com/XiaomiMiMo/MiMo-Code/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "b31dbb1f7ed1fb601778e30ef9b07de65968193937ddbfa42dc783dd4a058e59"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "17bb02569607d389a8b0b42283d1f796c6b36acc2ce8cb901abdc2de01619179"
    sha256 arm64_tahoe:       "ca2a1195e5d683b2abc9c43a40696f0ed02d5990c4fce146009496c1c66904da"
    sha256 arm64_sequoia:     "a488a9c80509e3541a151be7cc384c76876079135092122a55d5376ecda3d6ec"
    sha256 arm64_linux:       "5269a6d4db16412a0a208286bee5ba929366a79904fa25fd0b007d3f0e4efa87"
    sha256 x86_64_linux:      "04e1557a5c169824affeb2ed6df733dea099ff5b411898d0a7aa703f63b72e3e"
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
