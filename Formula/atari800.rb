class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://downloads.sourceforge.net/project/atari800/atari800/4.0.0/atari800-4.0.0.tar.gz"
  sha256 "08e9b989ddb2785265d242ff92b416a2b53c285c7309f3fc3f5e94889cb69eb5"

  bottle do
    cellar :any
    sha256 "3dbeacd2b8792c016a7b08d88372240bd45d6841e1e65ec6477fb1a322a013ae" => :mojave
    sha256 "7e796d1b72b0f04b7d396a132f39be6b0537150b085ee33dde648980ab325049" => :high_sierra
    sha256 "91c67cd09225e85b65ce6040c37608365afbe49428113c785973f9e32c3d2604" => :sierra
    sha256 "bedac5c5ac65f87e08c1983d130fbe88e02e056b154196f2add661f98cb2b973" => :el_capitan
  end

  depends_on "libpng"
  depends_on "sdl"

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}",
                            "--disable-sdltest"
      system "make", "install"
    end
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
