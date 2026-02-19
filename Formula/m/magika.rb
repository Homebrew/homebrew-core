class Magika < Formula
  desc "Fast and accurate AI powered file content types detection"
  homepage "https://securityresearch.google/magika/"
  url "https://github.com/google/magika/archive/refs/tags/cli/v1.0.1.tar.gz"
  sha256 "a1574996fadb4fc262e0d652dc9b8d6a837c0911e620245afe9d1ea3881ebfd7"
  license "Apache-2.0"

  head "https://github.com/google/magika.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d93f626ec1454d84cbc0b52e6e5c1fc1eb8552a2cdc29677a99a96e91b1e4444"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47f3471c44e457082fb3a995f41069cfba54a49dab6394c28342b807edb7c954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "388505c16689f93648258a297ee037950e3caa83f1fa4f07f50f2e688ab00866"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6fe3680a0f5b6f8256e96ae53eba014b798db39a2d9ea7656dc55a94084e3bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05f13de23f78e84aa077b96a4aef51865666ac158578472bada2bb1fbc8c5a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9010cda89964baceb390e0121198c0a9c55729455affeaa83956b3f290b0650c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args(path: "rust/cli")
  end

  test do
    assert_match "text/markdown", shell_output("#{bin}/magika -i #{prefix}/README.md")
  end
end
