class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.10.13.tar.gz"
  sha256 "c10adee3067ecb721fb3216df706daa8ae2d76f23739e9c58c8f3777454a5a5a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be65a791e452cd15292fd65c5425391eeb7175290393729f106fe8ab62f9577a"
    sha256 cellar: :any,                 arm64_ventura:  "95f0100393627832e5cd4d37de684097c1217b41e9e0a175cc2ff49c2a7ac098"
    sha256 cellar: :any,                 arm64_monterey: "2798a8396165c888fb46fd578b5960dfb7f19858d9f11258a85dbea0fc3525d6"
    sha256 cellar: :any,                 sonoma:         "aeb650b6ac9ea0c59470960ec0b5864c514638e2139c4fae0134e0e5ac244e7c"
    sha256 cellar: :any,                 ventura:        "3a3969d87368ce5ac96ac3a045685a66bd2c420530d10daad10c560448a07ee6"
    sha256 cellar: :any,                 monterey:       "b03e523f511fd9e08cd306d5630a81bb70edbd45eb954a7baa493b5dc9cd0ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "082ae0d8db289d191493a215d7db7d8234ffe60aa49e1e9da7207e7273a415c6"
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
