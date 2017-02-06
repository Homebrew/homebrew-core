class Curseofwar < Formula
  desc "Fast-paced action strategy game"
  homepage "https://a-nikolaev.github.io/curseofwar/"
  url "https://github.com/a-nikolaev/curseofwar/archive/v1.2.0.tar.gz"
  sha256 "91b7781e26341faa6b6999b6baf6e74ef532fa94303ab6a2bf9ff6d614a3f670"
  head "https://github.com/a-nikolaev/curseofwar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88605368194a451067920d6be53b2545a13180ba1ce74f6df2488a4f2c39609b" => :el_capitan
    sha256 "510f0fef5ed3355099a297a6588b1d9e94734a42b61c3d42bd336cf0706cb82d" => :yosemite
    sha256 "02a4add2f36df3da44a71cd5f7e9a367abdfc43a272559c14d41f0a9d68cdce8" => :mavericks
  end

  depends_on "sdl" => :optional

  def install
    system "make"
    bin.install "curseofwar"
    man6.install "curseofwar.6"

    if build.with? "sdl"
      system "make", "SDL=yes"
      bin.install "curseofwar-sdl"
      man6.install "curseofwar-sdl.6"
      pkgshare.install "images"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/curseofwar -v", 1).chomp
    assert_equal version.to_s, shell_output("#{bin}/curseofwar-sdl -v", 1).chomp if build.with? "sdl"
  end
end
