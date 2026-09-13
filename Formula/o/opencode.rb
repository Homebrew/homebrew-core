class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://github.com/anomalyco/opencode/archive/refs/tags/v1.18.30.tar.gz"
  sha256 "d54574de6a2b02d58fe4d403035103a08bdca0f4eafac63d3681cda774e85cd9"
  license "MIT"
  revision 1

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "74aef99234335cf4e7c74f724acb66218a21991b3873dd722b8a79b168976053"
    sha256 arm64_tahoe:       "37aa61490b80598c35055d0d3893c5aa21f40a17bdd64b8f1e04038a40927a9c"
    sha256 arm64_sequoia:     "d4e1dcfe36727e65aac1bc0e4ac2ef98e2b9cb2d113c0ca837e4474132fc7299"
    sha256 arm64_linux:       "9049d03d60e73f27050635acbcbb424a06f24fed80495ef5d3657fe1c234f1ed"
    sha256 x86_64_linux:      "22fcc4f26cd3e99c3e810a77724e59cec10860444b8f0066b8eafc05a116771d"
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
