class Proxify < Formula
  desc "Portable proxy for capturing, manipulating, and replaying HTTP/HTTPS traffic"
  homepage "https://projectdiscovery.io"
  license "MIT"
  head "https://github.com/projectdiscovery/proxify.git", branch: "main"

  stable do
    url "https://github.com/projectdiscovery/proxify/archive/refs/tags/v0.0.17.tar.gz"
    sha256 "e0c5bc3c8b0666ccbfd34cadbab972ddfe3737f01f1bcde9fddb265c96262a76"

    # Report the version of the release being packaged.
    patch do
      url "https://github.com/projectdiscovery/proxify/commit/af4d51b66733f93dae11c775c2ede39763bc4fe6.patch?full_index=1"
      sha256 "3135398ce9478934784965c62f2ba66f235343ecad30d50399d8841a303ea82c"
      type :unofficial
      resolves "https://github.com/projectdiscovery/proxify/pull/791"
    end
  end

  bottle do
    manifest_sha256 "2da286c4d10ae8dc282217e674f3e1111a1e6f1e0c8232acd41eb460963fd506"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be2ee187f746d136f5e3a9171a7fb6cc4a2772bb47f0786a9c83042613880a4e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "34dec2b71f029c5f2775a2ccbc203f6bc4ae07caaf22fcdb69233c69fe13d0bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "04a2742661f9f87e11595a0c1f3cf0946609366143e84b99f46580c1d38248fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba397f584a5de895a93f23d7d9b4b5dbd0bfb3247c64428cd2580ff6117df8eb"
    sha256 cellar: :any,                 x86_64_linux:      "75cc238ff5ef3662a1042d38eb9097d3f5c0fa96c50129dd2ef1d6d5bd2a1a44"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/proxify"
  end

  test do
    # Other commands start proxify, which causes Homebrew CI to time out
    assert_match version.to_s, shell_output("#{bin}/proxify -version 2>&1")
    assert_match "given config file 'brew' does not exist", shell_output("#{bin}/proxify -config brew 2>&1", 1)
  end
end
