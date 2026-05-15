class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v0.28.2.tar.gz"
  sha256 "5ef57be870ca678cc5fbd6237416edd2a298e88be9ec977ccaadb65766902a4c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f95eccf4898ee8c4c151cca3baaa33e417587cd25ff34c40d7eef95ac31ff953"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b445e60956b382ba381d4c2f2ec90c6a5cef5603169110d6c73652422f6e96dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4d2e842960d2aee05c55f3ad755741e34e90a42f694bca48a45e6d0cee75c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "de1a22b10ded70f7a0dcfe095ef7a1863221fdf99a8ef27f4f47d229c9818890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16e7c1d0758261305e7313950ba12e4b430c9764d2b82ddd58d85b2c11259238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c24a74906052cde2aaa2e19ad5648f1fc503aae003808dd59c39a726a919a78"
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
