class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2024.3.15.tar.gz"
  sha256 "2aa47779158e09625f1a012874e6200122727d595abb7e15e67a9f58535cb9d8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b261659ea64d67c4d77a4511f925c9afb4b672f90758665c5b2c30b56b78c1ff"
    sha256 cellar: :any,                 arm64_ventura:  "fb5c21cacbf32b14fc2782b343a14b08df02a1f64f860620fed4b7ca8a5db8bf"
    sha256 cellar: :any,                 arm64_monterey: "2c442820a3253827ff4586dd36afac95f0a7e7a520dbdf9d9d9929f078f35495"
    sha256 cellar: :any,                 sonoma:         "562d55f8fa1dee50805d10960dc22f276fff4fd70334115b0a4120ab38afb744"
    sha256 cellar: :any,                 ventura:        "cc53f6ba716e77e9f1894df7250abbb4264329383b5aed99becc45ed9ae434b4"
    sha256 cellar: :any,                 monterey:       "59f43bc002806728ad0ba8bdc378358539e4f7dbdc11e61d499b89118fd1709f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6cb34478b914acba08b631467010bc6ecd16859713e3a192bd9bcb9ebc3b11"
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
