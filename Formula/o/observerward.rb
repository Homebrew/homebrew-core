class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2024.10.9.tar.gz"
  sha256 "4f3a739a6083d9f58d9f2f3e97c659b50a0b0bbaab325ff920d7042a966e702b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1a20cdf2b58044ff318562fcc7a2ab43e6e1349f7c3e87338b831ca12e237f8"
    sha256 cellar: :any,                 arm64_sonoma:  "627d10dc2e456ee3930b478095dacf459ba6c816a0eea4ac621af227faee7831"
    sha256 cellar: :any,                 arm64_ventura: "a0d551da65846a90fd808f22798db4997a3b41cdf744fc9c63894de2da93f4ce"
    sha256 cellar: :any,                 sonoma:        "59f513d30e079d23506f46068fedbf81f7f57fd2296515987a9e5efc475c0fcb"
    sha256 cellar: :any,                 ventura:       "78a60b611afb3d304723f01aec94f8af55ae6ae365c773850e2db96c8abd0633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20a88b07f8f8d0fc0e68495aa755253867d59ccb2c7fd9aa56f444907b8740b5"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"observer_ward", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
