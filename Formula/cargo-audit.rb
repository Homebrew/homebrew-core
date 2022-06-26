class CargoAudit < Formula
  desc "Audit Cargo.lock files for crates with security vulnerabilities"
  homepage "https://rustsec.org/"
  url "https://github.com/RustSec/rustsec/archive/cargo-audit/v0.17.0.tar.gz"
  sha256 "18fc40de40b95adc55e4c4e767f969d62f60bba23805ea9455dd12c1c19f01c0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RustSec/rustsec.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cargo-audit/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2907ef46d191e14092fc49fa13f3e12bff7235adbd285c8f58bc10fe9c9c5531"
    sha256 cellar: :any,                 arm64_big_sur:  "e8f270631adf182683c230432d8a2abb533e0926732acd3e069d5ee9fc8c3131"
    sha256 cellar: :any,                 monterey:       "2d4d57d4e32bd7ad13a3119292bc0fe65c7ab6d337997af31c827c50c20b6d45"
    sha256 cellar: :any,                 big_sur:        "70045a4db0750f51b4c5681736a9834da19588038f22baf7a64beca550de1328"
    sha256 cellar: :any,                 catalina:       "6639e6779eb666b04c7ec11b58b76243c277681fda34cf6522c0106f3433139b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e9b3e19cd6ef431d35459456cb85d853880286ae6b8d4c774a68631f095ff7"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "cargo-audit" do
      system "cargo", "install", *std_cargo_args
      # test cargo-audit
      pkgshare.install "tests/support"
    end
  end

  test do
    output = shell_output("#{bin}/cargo-audit audit 2>&1", 2)
    assert_predicate HOMEBREW_CACHE/"cargo_cache/advisory-db", :exist?
    assert_match "not found: Couldn't load Cargo.lock", output

    cp_r "#{pkgshare}/support/base64_vuln/.", testpath
    assert_match "error: 1 vulnerability found!", shell_output("#{bin}/cargo-audit audit 2>&1", 1)
  end
end
