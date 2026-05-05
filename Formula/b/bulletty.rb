class Bulletty < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://bulletty.croci.dev/"
  url "https://github.com/CrociDB/bulletty/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "e13b5743ee66a1d62c87f1ffa791a0c290d031fbb5d9363ce2c1e81cda25682d"
  license "MIT"
  revision 1
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb415a2b4039680c6eace43e6af4763fefb71b437d9bce4d0bad199b39d087f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7733c11190f982f7976df718bfef07ffbf3c53dd8a1311c0076abe92e0130a69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b907e4c02067b76d345c62fa0010ac8aead5c49744e6d5dde259cb17025d3953"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2546aad4f98d0099aee5da1ae230d38f75dcd89ed5624283bf4cedd86ef9cda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "687efab8b3c8b790dc9a8633ec163e8b6ab0dd9352f54b878a5ac461b2677b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b338b398b9111ad128704e0f5945fd9e7bac34b89e325ea0b902c26cf01402a5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Backport openssl 4 part 1
  patch do
    url "https://github.com/crocidb/bulletty/commit/732f1c7c253d1f0819e14f112c999b5d4160eca4.patch?full_index=1"
    sha256 "5d5d8f7c8428ad994854ea825ab7029fbe3359492f6f395cea547eb7a24eb0ec"
  end

  # Backport openssl 4 part 2
  patch do
    url "https://github.com/crocidb/bulletty/commit/a2bc60cb5d5c5301c818935fa3d6ad36e5a78752.patch?full_index=1"
    sha256 "6b45b5cbd4f7c3410a5feab98f7b46c7923e4923b50876e56e2ba5841122f728"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bulletty --version")
    assert_match "Feeds Registered", shell_output("#{bin}/bulletty list")
  end
end
