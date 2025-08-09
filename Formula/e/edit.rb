class Edit < Formula
  desc "Simple text editor with clickable interface"
  homepage "https://github.com/microsoft/edit"
  url "https://github.com/microsoft/edit/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d91205513b245bf4ed1127c35d148cac4f7dafd22b071fe3443d080bbda4b9ef"
  license "MIT"

  depends_on "rust" => :build

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"edit", "--version"
  end
end
