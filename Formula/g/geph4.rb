class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.19.tar.gz"
  sha256 "6dfcb72c9042fa5d49b140234eccf57cfb7f63b3238e9733acd10f90923c977e"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d622a7e20ce88dff101b47fa6a1afbfe559b9981d94262fea64fcca42036fac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e826996c0becf4d576fb9951161e02570f42f008d9d15469ebd88a8b3546070e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e3cadc07293bd43bc487ab78ca644a907fdb0744568a95a9776424bfa708d5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f0ba81016f8571d410daad734993143d67a091fa2f51e43367693b74f673111"
    sha256 cellar: :any_skip_relocation, ventura:       "c3ffad6d37ad20d736bb06067ab9666d46d3e12cffed9e501cdf0ef1c245ed40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c397c06f3df3711fe107d9dae67fe191d0089f130817fcf09adcd5372e9383ef"
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
