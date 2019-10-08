class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v2.3.0.tar.gz"
  sha256 "870c6ab802ca4df6d12a5570b6883e7e3b190bbe6e2fa91282af9b294c8e68b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "83f39a695788d36e81ba308da53403aa7b160bad1895be20970a9f5feeba6ab0" => :mojave
    sha256 "4137060ab6b019b98c1f9f5f9dc357062563f9639add33798b52e1bddf733aa7" => :high_sierra
    sha256 "629c0ba06af7be85b205bd89c0430b2bbaf4200cab77ac86fc73ec7e824cbabe" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
