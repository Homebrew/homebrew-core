# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://docs.brew.sh/rubydoc/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class OpencodeNanogpt < Formula
  desc "Command-line to integrate OpenCode with NanoGPT Provider"
  homepage "https://github.com/LunaticMuch/opencode-nanogpt"
  url "https://github.com/LunaticMuch/opencode-nanogpt/releases/download/v1.2.0/opencode-nanogpt-v1.2.0-aarch64-apple-darwin.tar.gz"
  license "MIT"
  version: "1.2.0"

  on_macos do
    on_arm do
      url "https://github.com/LunaticMuch/opencode-nanogpt/releases/download/v#{version}/opencode-nanogpt-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "05fd95f64b5c197976aedd35df19d6715345ea0ddb8b195c2c65b4663af7a76e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/LunaticMuch/opencode-nanogpt/releases/download/v#{version}/opencode-nanogpt-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "904b690650671a4fda999a8d5501bc4af2a23b83769d34233e68da277a385599"
    end
    on_intel do
      url "https://github.com/LunaticMuch/opencode-nanogpt/releases/download/v#{version}/opencode-nanogpt-v#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7e3ce750e8a95145f9df919d9280ac5871288fe41a6eeb279b64c7b178b4dd10"
    end
  end

  def install
    bin.install "opencode-nanogpt"
  end

  test do
    assert_match "opencode-nanogpt", shell_output("#{bin}/opencode-nanogpt --version")
    assert_match "init", shell_output("#{bin}/opencode-nanogpt --help")
  end
end