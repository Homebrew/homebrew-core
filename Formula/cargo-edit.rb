class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.6.tar.gz"
  sha256 "3110b5ffa65ac958aa0c5fa2b4c69db967d2fc18a71de1a598153b4c22c302e0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "273762c9fc110bb1429af500c66125b5db89bbd6c587c75809d1eccc5ba9bfe1"
    sha256 cellar: :any,                 arm64_monterey: "9739e260d892b2fc8c988f451934a96c75c097f570f68c8dfb3f5a20eae890e5"
    sha256 cellar: :any,                 arm64_big_sur:  "f7cb861e8ed53dc776357b1cb3151e54b7edb77696684efaa5324ebf714d968f"
    sha256 cellar: :any,                 ventura:        "645670fe298d083e5a9215a349a4a5d4f9186a8c23a397d88245d953c58bf86d"
    sha256 cellar: :any,                 monterey:       "790b8bcca985c440a86333ca0b47d601836fd9d0f9eecd29177017b62ce1bf85"
    sha256 cellar: :any,                 big_sur:        "9d86f58a29d2a8bddda493be1acdf4cd468c7d1a5307bb97fd0257a65965c61e"
    sha256 cellar: :any,                 catalina:       "be46c95e93ddec9cf7ad38bd94af2d81d1ee5da8a7bdc7ef6d6df7e1a826f443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d1e4e975d3a1273eb137d6ff1d33d74478ee2df9c189864738b596311facbc6"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libgit2"
  depends_on "openssl@1.1"

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
        clap = "2"
      EOS

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system bin/"cargo-rm", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end
  end
end
