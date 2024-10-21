class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2024.10.21.tar.gz"
  sha256 "26d51a1e10396986dcfec62674444a107d75559511bc67b3056e848370166d64"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c33984a9937f1166b308d63a9ead3210aab8127441cc438155bf15bae35e6b6"
    sha256 cellar: :any,                 arm64_sonoma:  "21028fd336053259e999a3b8171530833d30c1359f4bb13bf1f7913364105c0d"
    sha256 cellar: :any,                 arm64_ventura: "73714ccd745e40c9a23bc14cfae3075d38e4f106d46e991e843a0e8ec07b0271"
    sha256 cellar: :any,                 sonoma:        "f9397fcef44d80a74e3944bf7ca74f446dfa4e590f7b0dd74b702d7401b75af2"
    sha256 cellar: :any,                 ventura:       "9b3a664cfb97d97cb0634df017528f21ae55e05ee24aad2efac71b428a4eae01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7926614a480e7a4def9282fe81975c5303eaa3eb7fcb19592f9ce09c8b6e556d"
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
