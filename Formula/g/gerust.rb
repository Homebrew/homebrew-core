class Gerust < Formula
  desc "Project generator for Rust backend projects"
  homepage "https://gerust.rs/"
  url "https://github.com/mainmatter/gerust/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "1036cc5461e91f775bf499575f2352cba8a91ac2c97d2b312bdc19601d300038"
  license "MIT"
  head "https://github.com/mainmatter/gerust.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4088854ea7624c0367d82474595215a3d84e6c90bc9715fdecaabb9bd732282a"
    sha256 cellar: :any,                 arm64_sequoia: "3f3d849386c161d5c80056e40b7e65e25e1736aaa5edd07d299b05240ada7588"
    sha256 cellar: :any,                 arm64_sonoma:  "42bc15fa8cf6bc962713383d235635699ac0497c4c8abb666a0c381690602c50"
    sha256 cellar: :any,                 sonoma:        "b909aa55c741d9aee270abc25b73652265de01ddd2f083f97f1048d10743f0aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a6191821b4239fcfca67f7991baedfbc78b32379012fd6d8b3e0e2e36986b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a5f6bf8d2ea34da1b57dc86f60931adc25fe48d61ec7bec58905c8c1ee20296"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
