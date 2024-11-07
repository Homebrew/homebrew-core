class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.16.tar.gz"
  sha256 "b0c1f9036c70a5b7cd534481ec211d471891aeeb8c6f9ad6b2aaa6e872eeee3f"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c36abe4b16f61c08b35d67e27aefbc2c88e29479b607e281d79cff985442d44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6dfe588024eed5e01e8917cf338991fe8b0388b45399e7171ab640a157a5e91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e654b96f2525ca1bf800457787027e30416ae8bc146f95b2b91be7cb00213992"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f9ae2ec5376a41dc6cda4acb7a884691e7d36c3615962139fd819d1796e344f"
    sha256 cellar: :any_skip_relocation, ventura:       "e2846fe419ae54e6606f00c80f8b713c84b43312bc45ad68c1d80fb233db5170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efc68e0aa2d8a7bed7fcea2e61cead8139e7ff8738eda961b55597ae9b380e3f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    rm_r(buildpath/".cargo")
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)
    assert_match "incorrect credentials", output

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
