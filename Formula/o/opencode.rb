class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://github.com/anomalyco/opencode/archive/refs/tags/v1.18.30.tar.gz"
  sha256 "d54574de6a2b02d58fe4d403035103a08bdca0f4eafac63d3681cda774e85cd9"
  license "MIT"
  revision 2

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "6eca0861d2393d59644241ffd768dec95423a62d72fc8d65af66e1bd22565942"
    sha256 arm64_tahoe:       "e6b0af7ecb05fd9a033a3f0a2547c1351ec389ec4b10b1de9ad602bc91319f4c"
    sha256 arm64_sequoia:     "4334a8e50a57fcb38beb8484bc04ccd130cff328aaa414e5a0daea1f6eb6156a"
    sha256 arm64_linux:       "a7ccff3922000524824e102603273d7bf5bb1a04e47c81cd53af67b6a1e5ce5d"
    sha256 x86_64_linux:      "81106fe0486c1347f80ee8b3b255da3a9c272ad460efb0425cfbae9305ddff56"
  end

  depends_on "bun" => :build
  depends_on "python@3.14" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "icu4c@78"
  end

  deny_network_access! :test

  def install
    ENV["OPENCODE_VERSION"] = version.to_s
    ENV["OPENCODE_CHANNEL"] = "prod"

    # Fix server errors when building with Bun 1.4.2 by disabling splitting
    # https://github.com/anomalyco/opencode/issues/48645
    # https://github.com/NixOS/nixpkgs/issues/563241
    inreplace "packages/opencode/script/build.ts", "splitting: true,", "splitting: false,"

    system "bun", "install", "--frozen-lockfile"

    cd "packages/opencode" do
      system "bun", "--bun", "./script/build.ts", "--single", "--skip-install"
      bin.install Pathname.pwd.glob("dist/opencode-*/bin/opencode").first
    end

    generate_completions_from_executable(bin/"opencode", "completion", shell_parameter_format: :none, shells: [:zsh])
  end

  test do
    ENV["OPENCODE_DISABLE_MODELS_FETCH"] = "1"

    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
