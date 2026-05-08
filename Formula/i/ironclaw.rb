class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v0.28.0.tar.gz"
  sha256 "a2e6d6e6937cccc3518395d365e45da433a2f0db80f565ead03afc7ef633ab01"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec97e126e2d9e2b02ccd1858279ddc63a1486bae9d69bb5a2d24f283c2a49215"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94eb2e9491748659c9ede945ed1e4936d4e2d58498c6a43a85f8f0feb9b23796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8824663840f30b3bf8a480b1a263ff1d1bb86284b0d9ad811a930b24e669001"
    sha256 cellar: :any_skip_relocation, sonoma:        "abd37bf7acca5241ef42ef13c5e9672d495bac55b76103c10dabcaa7522015e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "363c3ff9cc340338fc4e52153fe722b2f1106d76059cfb510361287950dbeca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbe27f44a8a50e29de913b372c2aebe2a4d2d313e7396e243d91cbcfddb0e450"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Missing required configuration: DATABASE_URL", shell_output("#{bin}/ironclaw config list 2>&1", 1)
  end
end
