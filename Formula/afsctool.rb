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
    sha256 "9b956b7c54385c3001e49f03672054b660e03f06b7831d0825f2bd613daa7cf8" => :sierra
    sha256 "f53e528302f21b5232f0cf0ba85107c9881059aab97dd6db0c8e3b4338dd6f13" => :el_capitan
    sha256 "b00e2da9028fbbd4fc1c1e5db0bcec7612f66ec7bd0799a3368efd2f6c9b6a60" => :yosemite
    sha256 "166e38496d45481d0031930b19c33b853f3a48816b12acafd66620d0e707412f" => :mavericks
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
