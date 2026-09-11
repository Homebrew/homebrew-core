class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://github.com/anomalyco/opencode/archive/refs/tags/v1.18.30.tar.gz"
  sha256 "d54574de6a2b02d58fe4d403035103a08bdca0f4eafac63d3681cda774e85cd9"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "4c049d8402fdfebea642661a60e7848f92b072da7cbf9f759c72e1359e7eb7a8"
    sha256 arm64_sequoia: "e733044c4f2243ebb3784c32ea3e78afc459a7de466eb6f5715eb1295a400b11"
    sha256 arm64_sonoma:  "f5950af0544a3b38165f3660872f1157106e84b4c80add5a66ad6af0f027d52f"
    sha256 arm64_linux:   "25c5346d52ecdbc2e07aaeef67a6ef291ff1ffa2074c560f2d5323a88991a020"
    sha256 x86_64_linux:  "412e7ab0304423abc663d58d679c940b575bcbf3a6e50e4ab1e2e57f109c88b3"
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

    # `bun build --compile` appends the JS payload to an already linker-signed
    # executable without re-signing it, so the embedded signature no longer
    # matches the file and macOS kills the binary with SIGKILL (CODESIGNING
    # "Invalid Page"). Re-sign ad-hoc to make the signature valid again.
    # Upstream report: https://github.com/anomalyco/opencode/issues/46313
    # TODO: Remove when `bun` is >= 1.4.1
    system "/usr/bin/codesign", "-f", "-s", "-", bin/"opencode" if OS.mac?

    generate_completions_from_executable(bin/"opencode", "completion", shell_parameter_format: :none, shells: [:zsh])
  end

  test do
    ENV["OPENCODE_DISABLE_MODELS_FETCH"] = "1"

    system "/usr/bin/codesign", "--verify", "--strict", bin/"opencode" if OS.mac?

    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
