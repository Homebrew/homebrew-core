class Ninvaders < Formula
  desc "Space Invaders in the terminal"
  homepage "https://ninvaders.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ninvaders/ninvaders/0.1.1/ninvaders-0.1.1.tar.gz"
  sha256 "bfbc5c378704d9cf5e7fed288dac88859149bee5ed0850175759d310b61fd30b"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc5a1eb5df34f13a6d63777b20ec5fea7a8a0351e8f9b8561e6ec95c42ced2c2" => :catalina
    sha256 "4cb75493161c6153611c727bef8837c6c41fbd5db8872239d682cabadc7d2311" => :mojave
    sha256 "75247d901255b6fba826ca60d909b5bb1c349c969b98f65275c898ca45b32b7c" => :high_sierra
    sha256 "3de94522f9f6f5560e1e6f354470aef0c46de68792fd93bd2b044d45db8328c6" => :sierra
    sha256 "b2d4f23349e2214d5a0c8b51218974b0f8b2704d333f1bca19ca4b4539e2b9f1" => :el_capitan
    sha256 "fc7369a82b14fa5879d2e072ac7ceaa1b6b7bd6cabd163e6bea8adb3a5670b80" => :yosemite
  end

  def install
    ENV.deparallelize # this formula's build system can't parallelize
    inreplace "Makefile" do |s|
      s.change_make_var! "CC", ENV.cc
      # gcc-4.2 doesn't like the lack of space here
      s.gsub! "-o$@", "-o $@"
    end
    system "make" # build the binary
    bin.install "nInvaders"
  end

  test do
    assert_match "nInvaders #{version}",
      shell_output("#{bin}/nInvaders -h 2>&1", 1)
  end
end
