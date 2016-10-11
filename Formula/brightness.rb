class Brightness < Formula
  desc "Change OS X display brightness from the command-line"
  homepage "https://github.com/nriley/brightness"
  url "https://github.com/nriley/brightness/archive/1.2.tar.gz"
  sha256 "6094c9f0d136f4afaa823d299f5ea6100061c1cec7730bf45c155fd98761f86b"

  bottle do
    cellar :any_skip_relocation
    sha256 "edd4123953a961e94ce78b076b116c987f668ca73e0a67339e908ead6ded8441" => :sierra
    sha256 "675d9a1b7e39b75d2b569fa4f148fbc2342dbcd4a1b23045763c0103058ecc26" => :el_capitan
    sha256 "360b009d1a2ffed665c9d9168b3f91edba44c8da8f08d2f307b09ee63f399e0d" => :yosemite
    sha256 "222e314519f00aa2ad858c718f0dbed624f486f307828ed93a85d1df4e08a8f8" => :mavericks
  end

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/brightness", "-l"
  end
end
