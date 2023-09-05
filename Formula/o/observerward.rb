class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.8.21.tar.gz"
  sha256 "9c1feb022447414b11b2bc63ba4b9288355cf5dbf07baf254cf1d1691864cb77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ee053dcaf82854bed81999e556ce1a24632edfc9f4bd88a24f084029ccd9db0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fecd56ebd862418b8b15e2ee91564263df820e00e7ab3113aa7ff6cceaf3af7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e30ae93512f9a7c147b49b098ba01b25c8ca7a35ce004bded36aa58c86a87e9d"
    sha256 cellar: :any_skip_relocation, ventura:        "19afba064ff34c43efd61da1fd16913f2ca63e9194b4bc7d0feb4c27ecd72537"
    sha256 cellar: :any_skip_relocation, monterey:       "8a677ee9e0cc51e845d883017a548f88d20354b635218cb7ee9d44a87af48e6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "249d6c29ba6df2819ea45b9746089738bb38cad2402eceddeb3537e422ffb4b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f463404e6a979b343e81befd559cc2ddb19b9d2cbfbbaae1b8f7ff89eb032f64"
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
