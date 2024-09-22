class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2024.9.20.tar.gz"
  sha256 "32c9854c7e2604173196ad655095f32805ce21359cfd9aadeb4f5147e86597c4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd64d9e5abd72e318d0111d634d3ca2331ebbf876c6d637d035639ee9e174751"
    sha256 cellar: :any,                 arm64_sonoma:  "fbf5a56bd28e1ddfd9314ca44184c6368128562b51bce783292ab710e0fb4347"
    sha256 cellar: :any,                 arm64_ventura: "689fd33e57ad71626843570111a57913b5d5b5a949f52a29a4de0b6a320bba55"
    sha256 cellar: :any,                 sonoma:        "6cf9c1f936cce4af7af5b6079be8ae4c1011663960c09d79fcb7ed914e894bb1"
    sha256 cellar: :any,                 ventura:       "655b72ae05086dc325003c695ef1f809cc26c45b4c1dfce36f6974141d5213f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77734af6ea6f0296ed0c72d45d8b683dce541d925d5f44ed5cd1a6687f0547a6"
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
