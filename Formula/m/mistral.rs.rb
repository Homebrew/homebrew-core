class MistralRs < Formula
  require "utils"
  desc "Blazingly fast LLM inference"
  homepage "https://github.com/EricLBuehler/mistral.rs"
  url "https://github.com/EricLBuehler/mistral.rs.git",
      tag:      "v0.6.0",
      revision: "3410183eec88bfc1f213ee8f447497f7037f5dce"
  license "MIT"
  head "https://github.com/EricLBuehler/mistral.rs.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    cuda_enabled = Utils.which("nvidia-smi")

    features = []
    if cuda_enabled
      features << "cuda"
      features << "flash-attn-v3"
    end
    features << "metal" if OS.mac?
    features << "accelerate" if OS.mac?

    feature_args = features.empty? ? [] : ["--features", features.join(",")]
    ohai "Enabled build features: #{features.empty? ? "none" : features.join(", ")}"

    system "cargo", "install", "--path", "mistralrs-server", "--locked",
                    *feature_args,
                    "--root", prefix
    ohai "Installed `mistralrs-server`."

    system "cargo", "install", "--path", "mistralrs-web-chat", "--locked",
                    *feature_args,
                    "--root", prefix
    ohai "Installed `mistralrs-web-chat`."
  end

  test do
    assert_match "mistralrs-server", shell_output("#{bin}/mistralrs-server --help")
    assert_match "mistralrs-web-chat", shell_output("#{bin}/mistralrs-web-chat --help")
  end
end
