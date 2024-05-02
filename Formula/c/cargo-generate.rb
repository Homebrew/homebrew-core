class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "7ef6c621fb5487de9b145ea0bc15e06d28964d632e1dab80eaa20f451687c1c2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4cd327babe71c5b9a3c0a6f5f8de9de8ffc5f02fa45ea49798419234126ab0d9"
    sha256 cellar: :any,                 arm64_ventura:  "7361a667c1d704d7e27252d59100f173ffa6e42a1aa2b685c87c0859796c1506"
    sha256 cellar: :any,                 arm64_monterey: "97ad08cec0949fc19daa9d352235fba9f244351a3388a4e04f8a2f8dadf3452f"
    sha256 cellar: :any,                 sonoma:         "d63d5cbdfb158f4d5034b8bc06325eb2b6499bd19a4e15f72ddb27baf94b8d60"
    sha256 cellar: :any,                 ventura:        "d57c546bf1c68437a20dd4c5f5c58d8dbd9484352995f970605f9d735590df5f"
    sha256 cellar: :any,                 monterey:       "4fb858a4acfe4f0c437eb23a9eebd698325ca81098434ef3abef2d87441393dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53d09feaa82cb691fe1dd62a6842f1d249a493cf5b413aa766ea64a95afc8600"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_predicate testpath/"brewtest", :exist?
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
