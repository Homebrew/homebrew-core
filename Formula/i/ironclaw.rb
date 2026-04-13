class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v0.25.0.tar.gz"
  sha256 "039da1591c71dee723d987dc785a9927ae5eda86f708f3f7990f95cb98397284"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b195ee4278e2c8b68e7fa662464d803d4d6e9481679874c0c1176f568c06e5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "847399944893105dffaecf2ed8676591402f50062236803222632224347c9426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a4c919d6c128e98fd09347f066a5b5bc934248604129af971bc30752bd4676c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a659ae42ef8213e933794ed468c89868ae84da7771d8913a409765c3b0d8de3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a64e737c021ba93517c3bbb157efaaa8acfee2974e25096649374bf18dd53ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c3b064e56b0958e58bf0c792b7a824732badb76aa5c3cbf2b21e88176a13ba2"
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
