class Ftjam < Formula
  desc "Build tool that can be used as a replacement for Make"
  homepage "https://www.freetype.org/jam/"
  url "https://downloads.sourceforge.net/project/freetype/ftjam/2.5.2/ftjam-2.5.2.tar.bz2"
  sha256 "e89773500a92912de918e9febffabe4b6bce79d69af194435f4e032b8a6d66a3"
  license :cannot_represent

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "110a5feb1831f3bc2fd8d5c4b4cc8315cbc27676c3f08f65e040b9b109ef4bb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09eb3674d68bc70c0a968bab37408395e82acb51ab594f36baae4275972ff9f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c40cff88de5ed098fbc6373f6ceaf998a63b1f8189e930afbdeb7ab352e207e"
    sha256 cellar: :any_skip_relocation, ventura:        "2a6730f7f7a27f783a412f4b42a5f4ee3e856aebc453e728c6d14aa8ae0f19ad"
    sha256 cellar: :any_skip_relocation, monterey:       "2ade860ccc3972b17cab846917f1759e2676db0240b30375f9a289db365dd1e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "84e96d642732ab02748dad0b9129c8094348d030bdb414adcacfb6633cc2d958"
    sha256 cellar: :any_skip_relocation, catalina:       "4440e1baa7919c2a6b7190b31f12067c20d1a532249bd22f842d84a821c3f8a8"
    sha256 cellar: :any_skip_relocation, mojave:         "039a1c54e4163cafd9e44b5efa4a3b9847a3375db5811b51db8557b5e92ba670"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a91c9e777574a9e50d2bd7f53b5f357c6bda8a9e0de522bbddcd59af4a52c5d8"
    sha256 cellar: :any_skip_relocation, sierra:         "31e7d5357421066e2b58cab199a690691a8897e442e1472acdb3d0d829657670"
    sha256 cellar: :any_skip_relocation, el_capitan:     "f94287203827dea6ac5031e695c217a48b1b69e939dcd68a489c8477b4100447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03bc2f284df267e0e2f669480b142ae11c5bf15066eebc0dc7de69c42e116d41"
  end

  deprecate! date: "2022-09-18", because: :unmaintained

  uses_from_macos "bison" => :build

  on_arm do
    # Added automake as a build dependency to update config files for ARM support.
    depends_on "automake" => :build
  end

  conflicts_with "jam", because: "both install a `jam` binary"

  def install
    if Hardware::CPU.arm?
      # Workaround for ancient config files not recognizing aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, "builds/unix/#{fn}"
      end
    end
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Jamfile").write <<~EOS
      Main ftjamtest : ftjamtest.c ;
    EOS

    (testpath/"ftjamtest.c").write <<~EOS
      #include <stdio.h>

      int main(void)
      {
          printf("FtJam Test\\n");
          return 0;
      }
    EOS

    assert_match "Cc ftjamtest.o", shell_output(bin/"jam")
    assert_equal "FtJam Test\n", shell_output("./ftjamtest")
  end
end
