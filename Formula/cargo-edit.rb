class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.7.0.tar.gz"
  sha256 "56b51ef8d52d8b414b5c4001053fa196dc7710fea9b1140171a314bc527a2ea2"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "02962a1a65b5259647e87a4b065e2ca7fee5da04de585e579b6a08772064ad73" => :big_sur
    sha256 "0a90a56248feeb9a2371ab94a82ddc111688d9323bb4deb92c9863d96fd36f1b" => :catalina
    sha256 "b26248fef6c09401f36f5d4c30c5cfa10b9944817c84f6b55b384fc7106ef31d" => :mojave
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      system bin/"cargo-add", "add", "clap@2", "serde"
      system bin/"cargo-add", "add", "-D", "just@0.8.3"
      manifest = (crate/"Cargo.toml").read

      assert_match /clap = "2"/, manifest
      assert_match /serde = "\d+(?:\.\d+)+"/, manifest
      assert_match /just = "0.8.3"/, manifest

      system bin/"cargo-rm", "rm", "serde"
      manifest = (crate/"Cargo.toml").read

      assert_not_match /serde/, manifest
    end
  end
end
