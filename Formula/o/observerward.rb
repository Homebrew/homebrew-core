class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.9.18.tar.gz"
  sha256 "256eeb4d6f3d2257e7f4113b03630cccc4f6b6af528d1a39b8521e7588c847e2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "29a0832116c2cf75387ecf7aefd9e50b637df7fee8c609370e52ea15d3e32e8c"
    sha256 cellar: :any,                 arm64_monterey: "9f79b28ffaff37fc38fa62bbd233a2f368c9108ea448d8992232e6c590c7fa0a"
    sha256 cellar: :any,                 arm64_big_sur:  "6778e5e5b2d826faa408b331fb4e93ac9190ab8ed0e65624e23617c62b6207ac"
    sha256 cellar: :any,                 ventura:        "f6d3a1c2724af0229f3ac8bae05baaa377c21a82da0e6802f16ff08a0c36f684"
    sha256 cellar: :any,                 monterey:       "bf7aa99432ae2a0151ff1d04a183e980247023c8eb6ec4248900972a7f155afa"
    sha256 cellar: :any,                 big_sur:        "f2c7c2fb805cb71ad78e2802ae26f1bd6eae4be1c48219de5c02a27c1f41676e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d17bfff2324d86b8147d3a4481d21ff39b4431a7a31410799e36ce330c6612b4"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
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
