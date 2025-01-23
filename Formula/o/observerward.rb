class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2024.11.5.tar.gz"
  sha256 "c5121d4c58e499c26cbb59ef6cc442964d27c23781e10028c5423365f0fc010d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ba76ce959514d512e1003808c2fc681fbe0869320d500c19aaaf8e4acd727ce"
    sha256 cellar: :any,                 arm64_sonoma:  "68d1374d86e498434eeed05c88b5073aba6612ddc67ab101f7afa2293e76d132"
    sha256 cellar: :any,                 arm64_ventura: "58618bcbf9f4f332f745f46e717c7ea0470c8bfa354b5bfa9c9f040d4ef4b2f6"
    sha256 cellar: :any,                 sonoma:        "e99ed15430d947f0c7b8bcf0187e86186d0fa1f24e0b51bc7cf27eb92edc6995"
    sha256 cellar: :any,                 ventura:       "7eb5c854196a1b8c855a905c7978d51f84a48815de8a80f1a23e6854d2d45be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71448f62b7f6621f2a8e88191438be3d38cb32ceb6dec7e720ce23bc43bd3890"
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
