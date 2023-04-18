class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "15fc841f50c3313ca8646240e937fb76b87d5270cd3db64042e48e819745e5af"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cddba8742edd307becd8bf74510d893108b06bb27771f93b533915c53754c123"
    sha256 cellar: :any,                 arm64_monterey: "6f7df8f2c4452b383291d33dae9c24a7e6fbd3986cc890d78f56b1ad3e13085f"
    sha256 cellar: :any,                 arm64_big_sur:  "482cd1bb86b33a3dae2819552f8e1a1511393b22dabf17fbe9cb1ff3512b1e79"
    sha256 cellar: :any,                 ventura:        "118c222fb49ced9d3193cb802160b566206d9d305e553bd151bc26d54ecd8046"
    sha256 cellar: :any,                 monterey:       "3bf4a7ad20bdf2648fefe3459703ae01c29ddd45fb3dc7e40deeb8692c155932"
    sha256 cellar: :any,                 big_sur:        "8d9352097065f6c68ebaf425e9e7c4394429dbf6a3c47901cd6c6c1a499fdd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81914293781ece90566832ee3736e472b53148b634daabdae6293d7e7d2277f1"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}/prr get Homebrew/homebrew-core/6 2>&1", 1)
  end
end
