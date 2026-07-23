class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "810b66717e94f944b7cdb9051b0952a027861d7f6d0bae7393295189cae55f8c"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3601468b29f531577afbafc1a4e2b2bec36df503ed618d1c34a07e9ac4d6c5ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e964ea84b33234ebfea52fa0218902bc4ba56f3790f14ea3c8b45f901773870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7553d09c50f9fa2ca32b0e2d713b2d0096ed534db4a0c5a0b5c44c6769757d0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "80de6e988dbd0cdf3eb9950650d681425263f1f2c459f5da9563029ffd69cbc9"
    sha256 cellar: :any,                 arm64_linux:   "ebd3dc42e9a5f1c6137785a9f04116e432394023d417cea218652d2d49e9e3f9"
    sha256 cellar: :any,                 x86_64_linux:  "30d26d3203fb0571c61394ba3c55bd3be9f8a29e50fbfd2d0305142f8830350d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
