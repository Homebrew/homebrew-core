class Mdoc < Formula
  desc "Command-line tool for writing scientific documents"
  homepage "https://kmaasrud.com/mdoc"
  url "https://github.com/kmaasrud/mdoc/archive/0.3.1.tar.gz"
  sha256 "6807701201e0149bdb09d2ca7f32590a646dfb238823a5f448384a844e8b78f1"
  license "MIT"
  head "https://github.com/kmaasrud/mdoc.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "libpng"
  depends_on "openssl@1.1"
  depends_on "pandoc"
  uses_from_macos "icu4c"

  def install
    # From https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/tectonic.rb
    ENV.cxx11
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version # needed for CLT-only builds
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/mdoc", "init", "test_doc"
    assert_predicate testpath/"test_doc", :exist?
  end
end
