class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/refs/tags/10.0.1.tar.gz"
  sha256 "2562943c29a9b3ce1b76685d9e7de1ad5109f80a35c6941e7853b31fb92641fa"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2902d22ca4f66ec6f1549cc6a391cc9b11eec6c00256a443b1298e8c22190b9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37c97dddda6da60c11c406b3e89b858ba97a82fd70bab6ec965b19ab5ba1f40f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e134ae5781d721d8f18a661fbfc6449e4a64f424d7cfa2b739eecd5c9a15d9c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6720db936685348595235d6645e8fa2a785673d76655252f2b8a02808e3622dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb0ada61e17bafa0698afe7fd63d3a00d3f3eca2611bf1e31f48624f315f798"
    sha256 cellar: :any_skip_relocation, ventura:       "621fa5b8468b1bcd55a6e7300653cbd8eb120e697374a3f3e00aeb5c414fae3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1b59bf4dc0ed116bf7c1ec94a706f0e48ba2c7523eff3abd77d421d5a54f0ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d66e42b9aab95ae691640efaeb89d232491d144010b208285fb73b986a0c4a6a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
