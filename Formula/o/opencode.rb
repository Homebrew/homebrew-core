class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://github.com/anomalyco/opencode/archive/refs/tags/v1.18.25.tar.gz"
  sha256 "44e9530d7be172005c7d60aef317440eecb85d557d94cce7fa35c5a7b9d9da0b"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "a9dc7628cd613d1a1c94b42256b0b450af438c0f9c9132651b363fbe14a4f730"
    sha256                               arm64_sequoia: "a9dc7628cd613d1a1c94b42256b0b450af438c0f9c9132651b363fbe14a4f730"
    sha256                               arm64_sonoma:  "a9dc7628cd613d1a1c94b42256b0b450af438c0f9c9132651b363fbe14a4f730"
    sha256 cellar: :any_skip_relocation, sonoma:        "1874884dee4b0c59100926a2061596b806cbeeff2f2f2e9c1b27b8b6c258ea6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cdd02b79694885c40f941342c971223076735c4e28887af9a37ec8bd8ba7b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df13fb71d73abeba66fb514e9f806bda22bbd831c8e66920f16a24d2271c1763"
  end

  depends_on "bun" => :build
  depends_on "python@3.14" => :build
  depends_on "ripgrep"

  def install
    ENV["OPENCODE_VERSION"] = version.to_s
    ENV["OPENCODE_CHANNEL"] = "prod"

    system "bun", "install", "--frozen-lockfile"

    cd "packages/opencode" do
      system "bun", "--bun", "./script/build.ts", "--single", "--skip-install"
      bin.install Pathname.pwd.glob("dist/opencode-*/bin/opencode").first
    end

    generate_completions_from_executable(bin/"opencode", "completion", shell_parameter_format: :none, shells: [:zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
