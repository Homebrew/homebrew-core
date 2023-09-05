class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.9.1.tar.gz"
  sha256 "22734a6ce838cdabfac20d02f68e7c60ad3ddf4029a43b74bb9abf94a745112f"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "126747853de9ee9fe692e5b50e27f1a3681a71c2e8f0958a9f23c819cef4cc1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "554a6a8ae639445ba0141f9dc4cb55445335e06b1db27c9a4d5fad432dfeba44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b2df86be8b4c79cd0c4d16604aaf00f833ce2e9482a98fcaa0f8bb1382e9676"
    sha256 cellar: :any_skip_relocation, ventura:        "f5b9f8bf7a59df033d77f94b1c6ac79f1aa63a329f9c5aadac2603a1e52582a0"
    sha256 cellar: :any_skip_relocation, monterey:       "d2131c3e8ba16e69c76b6ff1636816c3955edd747798e3478bd46faaa71ec1a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "39248b0e0e14fedea1170a324fc9252fc1487009c2517b9e3cf0544e2e5e9691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d743760f6bf76696e643e7c2d44819cf2cf75d924bf4989bf53ab3e72cc09cc"
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

    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
