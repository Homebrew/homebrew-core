class Ninvaders < Formula
  desc "Space Invaders in the terminal"
  homepage "https://ninvaders.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ninvaders/ninvaders/0.1.1/ninvaders-0.1.1.tar.gz"
  sha256 "bfbc5c378704d9cf5e7fed288dac88859149bee5ed0850175759d310b61fd30b"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5086f1e6f104b199763ec9feedd2a3ee64340abf584d3dc2ea2fc50201ecb3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79c809a98982d7c68e1f31b53ff2644a750589f26e7a4fbba771b556d4929e46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "641248bbd6c7f8895dd3c6f42ce68f047db05864354ef772b7c2490c9ddced5d"
    sha256 cellar: :any_skip_relocation, ventura:        "722274c2a69c82b9498dcaaf29da198deae44e81e51a320872d4c6003340dfd7"
    sha256 cellar: :any_skip_relocation, monterey:       "7f4fce96d25e44373e785000fb3c2605b90bb8f33e8635f9031a4fd1e547a419"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4b326a63fb608eee71916a19751837d8cc98167b32ffd11b4f0328fcce82a5c"
    sha256 cellar: :any_skip_relocation, catalina:       "fc5a1eb5df34f13a6d63777b20ec5fea7a8a0351e8f9b8561e6ec95c42ced2c2"
    sha256 cellar: :any_skip_relocation, mojave:         "4cb75493161c6153611c727bef8837c6c41fbd5db8872239d682cabadc7d2311"
    sha256 cellar: :any_skip_relocation, high_sierra:    "75247d901255b6fba826ca60d909b5bb1c349c969b98f65275c898ca45b32b7c"
    sha256 cellar: :any_skip_relocation, sierra:         "3de94522f9f6f5560e1e6f354470aef0c46de68792fd93bd2b044d45db8328c6"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b2d4f23349e2214d5a0c8b51218974b0f8b2704d333f1bca19ca4b4539e2b9f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4d884e93ed10e3c362cd6a7b948aba5099efe9921dfa45a5163f0e0a2136da2"
  end

  uses_from_macos "ncurses"

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
