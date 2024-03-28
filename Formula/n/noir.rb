class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://github.com/noir-cr/noir"
  url "https://github.com/noir-cr/noir/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "2fa8e8956fb16a69aefcfc3538fae95c96fa3e68467e41fece6fc1d6e4433363"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "3330fb3ace93d5334817f2f6955f095a38a67e9a43e111f5884b2a5bdb8d213b"
    sha256 arm64_ventura:  "33a2253b44e326650b8d9d66ae90eead30c2dce63350c7472be851808ad5e1bf"
    sha256 arm64_monterey: "267a8ebfba8aa81aee4eda1bd4c48c7a56c259e19849e104366124ec6c709f14"
    sha256 sonoma:         "c0e4d90e00b2b08f40661b4053b7a14599e1778e02a83c214c8a3c6220cae2f5"
    sha256 ventura:        "73399032914610837addd4ef963261847c172d28a54812e1e13fa45b88925267"
    sha256 monterey:       "c8bb917ebe6f600ac141906c10e8638413893f53cb24f2d701b85bf23370498e"
    sha256 x86_64_linux:   "6f9680ba31afb9d9fb51def7b355bcbe4802c17dfdb463af7c9b090a3c45ae80"
  end

  depends_on "crystal"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "bin/noir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    system "git", "clone", "https://github.com/noir-cr/noir.git"
    output = shell_output("#{bin}/noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end
