class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.7.1.tar.gz"
  sha256 "f7e7d286e0e3b8003e1e758b59f8aee1fa2dd24e1c9aceb03d4e603cb8efcad4"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca11890ec7e64ca56ca323a81f7aa13b16f2b17920055c57ae0c5cba61c5f909"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c414593cf0e104f8d6e2533a60bb8b84cdea746979c0a78ee77579f16160bb02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "853f3505aa76f132c3decc2beeb078dbbc820ac029c9d0b380bc92fccc6caefa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76255d15e1004ad0f221385140922b681d0b86a60fc6cd8fe38d885e1e6b7ac0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f59ec8540e631ef2638cea25659f5d0d440ad080ddc776883bd8bc87bbf65eb8"
    sha256 cellar: :any_skip_relocation, ventura:       "2e7c24cf96486214b2a7674e5b3d4f4454b74a1c4e6858620128dc9b73b187c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db7f69c2b1b09fd39dba3c04c1f9fa598d5d5d7e5c0ff7867bafba85b937d636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "866c1952cc923ea0347d00d07766bde3cc678f46cb39df4ab34fcb3b635ec3af"
  end

  def install
    system "make"
    bin.install "deark"
  end

  test do
    require "base64"

    (testpath/"test.gz").write ::Base64.decode64 <<~EOS
      H4sICKU51VoAA3Rlc3QudHh0APNIzcnJ11HwyM9NTSpKLVfkAgBuKJNJEQAAAA==
    EOS
    system bin/"deark", "test.gz"
    file = (testpath/"output.000.test.txt").readlines.first
    assert_match "Hello, Homebrew!", file
  end
end
