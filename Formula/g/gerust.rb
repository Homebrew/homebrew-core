class Gerust < Formula
  desc "Project generator for Rust backend projects"
  homepage "https://gerust.rs/"
  url "https://github.com/mainmatter/gerust/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "1036cc5461e91f775bf499575f2352cba8a91ac2c97d2b312bdc19601d300038"
  license "MIT"
  head "https://github.com/mainmatter/gerust.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e1b300402425eaa50ab89924e093464fc996c99df1e4e58f49fb2467585b7001"
    sha256 cellar: :any,                 arm64_sequoia: "33193f2009b585cad43201824cd2d2a10569a273a4a0e857074a4782b68eb731"
    sha256 cellar: :any,                 arm64_sonoma:  "f982608ccbbf5920150ba1da309deedf904ccdfbb55f65645bc67017431bb852"
    sha256 cellar: :any,                 arm64_ventura: "cdf0346134b5e38f31a52465f2e5ef660cc4ef055c8edf48b52e0eced8fb8e48"
    sha256 cellar: :any,                 sonoma:        "e3fada255164a12a603566a0796a15cf35b40dda3ce167c71fec7aea2012e7d7"
    sha256 cellar: :any,                 ventura:       "f48ad8062f7f82cdcac0f0c39880c5f5e16449136da27c18772631bb9cdf7684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38227ca16c223d4da02f370146057e94d96485d99bb2eacb5797c9cd7a36b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4698c604170fa0fd07d963ccfc1f099db70e530ba6f476a7d1ff6a611a4d9589"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/gerust --version")

    (testpath/"brewtest").mkpath
    output = shell_output("#{bin}/gerust brewtest --minimal 2>&1")
    assert_match "Could not generate project!", output

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"gerust", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
