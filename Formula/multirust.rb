class Multirust < Formula
  desc "Manage multiple Rust installations"
  homepage "https://github.com/brson/multirust"
  # Use the tag instead of the tarball to get submodules
  url "https://github.com/brson/multirust.git",
      :tag => "0.8.0",
      :revision => "8654d1c07729e961c172425088c451509557ef32"
  revision 1

  head "https://github.com/brson/multirust.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e637caa68fca005e21846abb579a7487df02e3413f32efb01885a2c5e1746e6" => :sierra
    sha256 "18f1e661ce701e74f18d525a75e6c4ceb6e82f4096e77354452acec76593d43c" => :el_capitan
    sha256 "b7eb9f2d07493cda17eb49e9b79654c1f0ce4c60cd22b0e53e6b60469e3d32de" => :yosemite
    sha256 "26ad5ec92fbf20e556bffd4a73fdd7ce968db17c9078f626c497a91897fad4c7" => :mavericks
  end

  depends_on :gpg => [:recommended, :run]

  conflicts_with "rust", :because => "both install rustc, rustdoc, cargo, rust-lldb, rust-gdb"

  def install
    system "./build.sh"
    system "./install.sh", "--prefix=#{prefix}"
  end

  test do
    system bin/"multirust", "show-default"
  end
end
