class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.12.29.tar.gz"
  sha256 "93424f86535c0f08e301f5ea273cb512b5dcc8d17dfb4958a8d95bd48d086ac3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0792f237f58013bbbe1d701a775952dc15db5a5608f1e4db8ae795ba4e3a5f88"
    sha256 cellar: :any,                 arm64_ventura:  "02def2b06d63005c8e0d3d2ddb7f8bccbe4e83953e99efccb7e5bfeeaca6a4df"
    sha256 cellar: :any,                 arm64_monterey: "263a4a59f7a06388ecd85d2e0188ee34a797e2743a99ef1863fa4bc4908ee811"
    sha256 cellar: :any,                 sonoma:         "13900b8ada8800d08df85263b8b69f9c1270c9cdec362bc583a5deb08eb24795"
    sha256 cellar: :any,                 ventura:        "604720470ccae835f412ae2484530ae3c2663d4c981694e905877a7cd48e8054"
    sha256 cellar: :any,                 monterey:       "fe9eb3552dbeb72ec36b66173f75e524cb2632239c07307a69f7f22232e30cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6e06ce094716d2af99892e306df0e517e586de875e63cf498580c9e9e6dcc0a"
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
