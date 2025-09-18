class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "f8a2e04366e383a69f1077fb0a3607a44418ab98da13fa4718a79ec633dd975c"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd541aab41faafda34ff5082ce43ef9f2d3f3638f9ec79bcb66a62b9eb14c9e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f25f9d87c90cdb9242a19cc7fda93243ce679192c8a603f2db59b60ac4af5e84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c09440d6f94f6f52a39bd0de9458e6588b953d0a82f3b0a020d82302d47bb8c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "92be32f8055c7ae5b881a44631db8e14d892cf304563a610a01f8b34fe4db34e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "702d95c9ec88a775b5d7618bab78ad9faa2b62f82147d398369f2e4f0d9aecbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39b25bd2cb6cfba3f2c7749f5fefbbbd1d2afbe1bdf72a6b15f7fd9da980851c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"plakar", "agent", "-foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    system bin/"plakar", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo

    # Skip linux CI test as test due to `failed to run the agent` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Repository", shell_output("#{bin}/plakar at #{repo} info")
  end
end
