class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.17.5.tar.gz"
  sha256 "7fe9998fe5ec6c45c44cc05a07d266f4ef5cdebfdb71a8445dcb337df5778b57"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e6516db9d317d34e4ad684eff9562c01462ee8ad191d024cb93657b8ac43c80c"
    sha256 cellar: :any,                 arm64_monterey: "e57446927559666a5d71619c9ed850d8c8335608c11b7909c36cd619b55af383"
    sha256 cellar: :any,                 arm64_big_sur:  "d3e18b9a3a26f2c77617652a68a8949732deac2388a04d145ead5cec4a072ab4"
    sha256 cellar: :any,                 ventura:        "78fbc39088406151ff674489897cfae9c0d4714552c1a826f50482b68e48d611"
    sha256 cellar: :any,                 monterey:       "0250fd5762c3f97b023cf4e29cc924ff74bec59224c0da39685b88c55e57e0ed"
    sha256 cellar: :any,                 big_sur:        "0048040a6c8273edb46378acc0d0ab67117bb8c50e4debd339af72ddf5f034da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51574735ae3e10950bfb66eda16ba247533a59783f9bea82dbc26edbe1acbec6"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-audit")
    # test cargo-audit
    pkgshare.install "cargo-audit/tests/support"
  end

  test do
    output = shell_output("#{bin}/cargo-audit audit 2>&1", 2)
    assert_predicate HOMEBREW_CACHE/"cargo_cache/advisory-db", :exist?
    assert_match "not found: Couldn't load Cargo.lock", output

    cp_r "#{pkgshare}/support/base64_vuln/.", testpath
    assert_match "error: 1 vulnerability found!", shell_output("#{bin}/cargo-audit audit 2>&1", 1)
  end
end
