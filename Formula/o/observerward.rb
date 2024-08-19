class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2024.8.16.tar.gz"
  sha256 "000bde80f9e78c40897a59672d892286b384610279fae9d7ef5092b71b2cbbdf"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "22532a0b8b89f49b91b22b068e34a69fd357c50d02008ac8d36e135f3b1f4a10"
    sha256 cellar: :any,                 arm64_ventura:  "9a805d24872f20119bb0b8d8db90f657b197060a76f2d154ace486dad2e454dc"
    sha256 cellar: :any,                 arm64_monterey: "f81e04be72623bdba4147303f8ce382f78c562477d4d40d7bc01c36ebe213c72"
    sha256 cellar: :any,                 sonoma:         "a18f1d8be27d3984ebe196c8c7b2025498f5d7b7cd98108722e612ecca027f6a"
    sha256 cellar: :any,                 ventura:        "7da0bd2dfa7cbe10d1f900f4b24d96a0be45574823e700c90576cf809745989b"
    sha256 cellar: :any,                 monterey:       "8710451a2a1acb069095b455b3bdae127446df53e1c5c012834a35e31e993748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e66f47fd0d5c622490d9396c2d3e2872b5146c489ef799323e2abfcae2546b14"
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
