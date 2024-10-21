class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.10.tar.gz"
  sha256 "f782915a5441a7c01668eb45c7a5e67d879468d75b92574ac9adaa21aa086baa"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f775bb0596190471388fe84f099cd130bdbd4e428bda0a29a20e9166f1b40072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20201844c534dfd3119d5a4b58e5b03390387aeb3ac8910d81845fb420ee03dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "062d91fa3dd243ce6d703a2b69adede670503f57de072aeb0e99161711f36afa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3003b9f48c67d2fd805a186a92d2384cda84cdd67762d84661d8acec2d9f6bbb"
    sha256 cellar: :any_skip_relocation, ventura:       "c182e0dcd9ff536079212eae05da5afc80ca777d5ee850d8e8fadeede867b1aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c01aa3c1b71304643cbc7e7580a38c1682861f78624a17b984ed1da53bc573"
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
