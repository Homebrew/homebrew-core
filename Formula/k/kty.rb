class Kty < Formula
  desc "Terminal for Kubernetes"
  homepage "https://kty.dev"
  url "https://github.com/grampelberg/kty/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "050c8b0df88f65e1a06863bea99495b77bf2045829825e7e130756f1828c6aa6"
  license "Apache-2.0"
  head "https://github.com/grampelberg/kty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41ffc85a1afa73590d563262abbe3c3037cd0ea6ce1b2a4e315b789de481c709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb4ba6e5d3a1002a498075b31b9ffc694425ba048333ecf2ee662db7f08d1d64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a01a6547caa11fd487eb9470ed8552bd699731eb3011eabc38c4ce1fe9bc07d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "773957f43cf0e1a552700e177d52a0c4dc9a16738e6d33fad6fc1b3981f33e0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5dbd72cf1840b254b2ac815e8dad173883c8cb83140634976e29a14fcf8b65d"
    sha256 cellar: :any_skip_relocation, ventura:       "844450842762cb450a2885857744a5ea3a095d781db143312f3ff4607ec7b890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12eaaeecb6106661c66894aca09a5f73eb77d9be2ba51419f1d78eed9872aed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdd2bbe08fcd0a77a2402d91f009d13d4c9ddd5b51d533d4810e26aee40fccb9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    inreplace "Cargo.toml", "0.0.0-UNSTABLE", version.to_s
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kty -V")

    assert_match "failed to read an incluster environment variable",
                 shell_output("#{bin}/kty users check brew 2>&1", 1)
  end
end
