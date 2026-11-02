class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://github.com/XiaomiMiMo/MiMo-Code/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "dff948e338bf58e7d580a18fc6385f6669c66512e001fa8e08113280d4cab6a6"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "eff3915982f7a651a23c7774489756685c4f97940e7be5d52a43a09dc2d4fe73"
    sha256 arm64_tahoe:       "98b81835e414d6572e457558d9c93e35f94546c5f57667d33bf6e58733ce6b51"
    sha256 arm64_sequoia:     "c0a26eca958bedc1cdf73c50dd54d2229e0491e2ebcf2265258172d8d6c46b77"
    sha256 arm64_linux:       "6ea98cb741ff9f3f5b25e729214f894c91587a71b7d4c54a051e86cf1b57230d"
    sha256 x86_64_linux:      "2d01aff12d4db0b3ea580940fef72e53a408122751dce56d15ef147d41bfe758"
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
