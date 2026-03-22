class Gitnr < Formula
  desc "Create `.gitignore` using templates from TopTal, GitHub or your own collection"
  homepage "https://github.com/reemus-dev/gitnr"
  url "https://github.com/reemus-dev/gitnr/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "835f56863b043d39f572d63914af07bbc9e0a7814de404ebc0e147d460e10cdc"
  license "MIT"
  head "https://github.com/reemus-dev/gitnr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6f55ca6ffd7a5014925821fe4377caf19874f75837f9a5396dbd12482221d0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a46abfed2d446a26fd0bdf62c04f7136282411a585f6191f8c95a2b2018586a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f43cc5851f5fc45ffada1fc2f12ec45ea95358659833402f29821541579012ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "96444e77d1b7399ac511fdd49fe358bffe34717f97f820047d09e21f59981f9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d72e48d034a9e4298b71f1cf912286668a9b898381ab8ffc2c960918d18df611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcb4d3b8d42018f3f4c5273361a9f375000bfecccfb59b32f04f45246ab166a0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"gitnr create gh:Rust"

    system bin/"gitnr create gh:Rust > #{testpath}/.gitignore.rust"
    assert_path_exists testpath/".gitignore.rust"
  end
end
