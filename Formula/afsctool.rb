class Afsctool < Formula
  desc "Utility for manipulating HFS+ compressed files"
  homepage "https://brkirch.wordpress.com/afsctool/"
  url "https://docs.google.com/uc?export=download&id=0BwQlnXqL939ZQjBQNEhRQUo0aUk"
  version "1.6.4"
  sha256 "bb6a84370526af6ec1cee2c1a7199134806e691d1093f4aef060df080cd3866d"
  revision 1

  # Fixes Sierra "Unable to compress" issue; reported upstream on 24 July 2017
  patch do
    url "https://github.com/vfx01j/afsctool/commit/26293a3809c9ad1db5f9bff9dffaefb8e201a089.diff?full_index=1"
    sha256 "a541526679eb5d2471b3f257dab6103300d950f7b2f9d49bbfeb9f27dfc48542"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7f11c9c16fb0f5f148fb80f1888cfa1053296e8f552b11cc196a6c3fcf0afade" => :sierra
    sha256 "0751efedf08e3d0c4efed48861aaddf150bec2fdabc7099306f576a8c63c4971" => :el_capitan
    sha256 "a05524c78e0153712e5a9d1a73fe70ed2e5f0e5e20a91ae38fedf9115d2e87a4" => :yosemite
  end

  def install
    cd "afsctool_34" do
      system ENV.cc, ENV.cflags, "-lz", "afsctool.c",
                     "-framework", "CoreServices", "-o", "afsctool"
      bin.install "afsctool"
    end
  end

  test do
    path = testpath/"foo"
    path.write "some text here."
    system "#{bin}/afsctool", "-c", path
    system "#{bin}/afsctool", "-v", path
  end
end
