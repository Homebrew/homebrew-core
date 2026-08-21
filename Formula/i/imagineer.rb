class Imagineer < Formula
  desc "Image processing and conversion from the terminal"
  homepage "https://github.com/foresterre/imagineer"
  url "https://github.com/foresterre/imagineer/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "2511068e1919ee67af1fb9203a1bbcfc9f24894cd3b2e341c52d493e79535e93"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/foresterre/imagineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ca11e59cd76c386376633456490a78f142113529373e9952d6eaa0498bff96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "892c752f9fc92344c70641c0f7d844a92e67bce6dadc0284acaad63dc33adbd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca30b3c969ee7ed9047b97cbdabb8b11daefdfde8798244a2a127e31f7e6c54d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1308d6bc4541aa18bfc40a1d40ae5fba35584624669aeebd234802858937765"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f4057299fe24aa4fe3991b89269ca831417b64f96f6aef7f92b06a34ba3a4fb"
    sha256 cellar: :any_skip_relocation, ventura:       "b9058702f0d82940053f9c6f17ba5967d84cd17d9d04c62bf3ec960322b70c43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e6bbcfec405b3c2f501296234ce3b1a6dd9c01a855b4d27023d5c9e20c2821f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "221eef6b88965107e0ecbad082d7bbb16394df8f1f8eb26786e8735a8b367941"
  end

  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ig --version")

    system bin/"ig", "--input", test_fixtures("test.png"), "--output", "out.jpg"
    assert_path_exists testpath/"out.jpg"
  end
end
