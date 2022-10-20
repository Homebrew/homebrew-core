class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.17.2.tar.gz"
  sha256 "6889af7fde60ad00f1702808c8d57b603c8b8be3cc9f64e8c2e8206cb0742c4c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "aa70beb8a8a9e6e1da08bff1e4a1151a1433caaddcdf55f0efc8563ebeafcbf4"
    sha256 cellar: :any,                 arm64_big_sur:  "f25e756272b472793238f7bc2d2ba223d293873e8bb77d0eca13a87024b7ece2"
    sha256 cellar: :any,                 monterey:       "de6eaf91a4e7b92e4ef3efbc913fa841024993410ca89e9be554fe35e3a3b653"
    sha256 cellar: :any,                 big_sur:        "452c29ba4efdf76d93740b9a7023689402111b32e0e5daf4d02a5b2cb8471bdf"
    sha256 cellar: :any,                 catalina:       "593e954f666c8b12da859a148e2eaaef93375f5aacff8ebe10d0bfac6e3c3ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f00f9a54188031f542a5568afc067ce0048472710dd5e9cd06d2930c51735776"
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
