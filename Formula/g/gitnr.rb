class Gitnr < Formula
  desc "Create `.gitignore` using templates from TopTal, GitHub or your own collection"
  homepage "https://github.com/reemus-dev/gitnr"
  url "https://github.com/reemus-dev/gitnr/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "06b1ab4a5ff56c815162485a9d90aae1d72b0c042f9be15b7db20c210a80f378"
  license "MIT"
  head "https://github.com/reemus-dev/gitnr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19d671e9aa59d3b9268bd5ecf1a7445d5852a0aae534e811eadd596453fddd8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "647778b97434da70c9d806021104d0db2e59f9d403dc4ebe4ae3be11d5978181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f5517f7c25e189c20957f2f54ce7c01f0c9940258c3ab816dd44256c163624d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2dab080f29641d3c8dc0a0764749fe9be5e13692f718e14c56035ede56de70d6"
    sha256 cellar: :any,                 arm64_linux:       "da4e5423a92a5d5927174233db2e57e98bf00538782d6b8937e9aac2c4acf763"
    sha256 cellar: :any,                 x86_64_linux:      "4f5cdd8b9a1c98b935282907cb754a7a5e57e2c45e3a8150cc11a7f634c53bf0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"gitnr create gh:Rust"

    system bin/"gitnr create gh:Rust > #{testpath}/.gitignore.rust"
    assert_path_exists testpath/".gitignore.rust"
  end
end
