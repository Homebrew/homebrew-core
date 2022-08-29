class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.32.tar.gz"
  sha256 "2ec9a861885a2ba3a523166636e08dd40116fdd870f088f84ca8d57949087e84"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d785efc734529e28a5afaaf57a9671fdcf609aed45c681285b30909be93c7b4c"
    sha256 cellar: :any,                 arm64_big_sur:  "1fdf5aabf89c87398eb282efcf172335d2bfe80835b02b4367e6fd5eab4c37c6"
    sha256 cellar: :any,                 monterey:       "38cf4b2fb8ae3aa62766464a38b81b3a3722d7e0d12bbcffc5176b2d06f589d6"
    sha256 cellar: :any,                 big_sur:        "09aa34ef942b584ea771e94d97b703c4684be4e3bdc07a742c7bce4a7572df58"
    sha256 cellar: :any,                 catalina:       "360ccc620928faa7a624176a3bdfe032a536054af36bb37776f9161277731585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f594ebffe89bcd1a27ec5dd93d00f2cf258f793ec65bbc293d7b6f50edaca9f8"
  end

  depends_on "rust" => [:build, :test]
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "3"
      EOS

      output = shell_output("cargo udeps 2>&1", 101)
      # `cargo udeps` can be installed on Rust stable, but only runs with cargo with `cargo +nightly udeps`
      assert_match "error: the option `Z` is only accepted on the nightly compiler", output
    end
  end
end
