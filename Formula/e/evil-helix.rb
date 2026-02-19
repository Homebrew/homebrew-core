class EvilHelix < Formula
  desc "Soft fork of the helix editor"
  homepage "https://github.com/usagi-flow/evil-helix"
  url "https://github.com/usagi-flow/evil-helix/archive/refs/tags/release-20250915.tar.gz"
  sha256 "1a5dc826890eede336b2f2cabbb1bb19b3e25ebbc0c42ac09eb7d9348bbf27cc"
  license "MPL-2.0"
  head "https://github.com/usagi-flow/evil-helix.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "088ce87991fec98ca0f5d28f7a781841cbe12259b24fb938f3082999e9b6ba83"
    sha256 cellar: :any,                 arm64_sequoia: "aa1c077d84f8167f6603695b83b2818138e65e91a42ef39791eaac40d4a6815e"
    sha256 cellar: :any,                 arm64_sonoma:  "28f7341d9919b9f9ac2ca92626620ee991239c6cf5790cffe08f77423e241e67"
    sha256 cellar: :any,                 sonoma:        "3827312aed2b160a604b9afa49ba2180af52f64782fd30317ef93b8c85ea0797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1b10ec389c6c35d93edb3068ddb9b903745a0c57de1c672ae384c4b16fca17d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c13f92143ffc80c200cf99fab67afd167cb9c0dcf64b559c48db9b27734d3b1a"
  end

  depends_on "rust" => :build

  conflicts_with "helix", because: "both install `hx` binaries"
  conflicts_with "hex", because: "both install `hx` binaries"

  def install
    ENV["HELIX_DEFAULT_RUNTIME"] = libexec/"runtime"
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    file = "https://raw.githubusercontent.com/usagi-flow/evil-helix/refs/tags/release-#{version}/Cargo.toml"
    version = shell_output("curl #{file}")&.gsub!(/.0$/i, "")
    assert_match version.to_s, shell_output("#{bin}/hx --version")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end
