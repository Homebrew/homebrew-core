class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.1.0.tar.gz"
  sha256 "200a4f9331d0e5048bf9bda6a8dee38248c557e471b9e57ff3784853efd613a9"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "be94287535d61d1c180bace2ec77492a8de092539ace76b770d53c5234704e69"
    sha256 cellar: :any,                 big_sur:       "f651173535b859cecca10d2dfab28ff78c184cf1e16455ec296fae2d509d2aad"
    sha256 cellar: :any,                 catalina:      "2601b6b120df50c7790d5b2f8dcf06848ddae0b35315affec641dec17271fa46"
    sha256 cellar: :any,                 mojave:        "7c9b9ac633b0339fead96c6e611b87bcc6df9f7fe0947dac76908340290707c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb5ac6bbfb4109cc5824ae40753bcab7fb08c9dd5b87ff0f41ea76e369d92545"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "ncurses" # enables mouse scroll

  on_linux do
    depends_on "lm-sensors"
  end

  def install
    system "./autogen.sh"
    args = ["--prefix=#{prefix}"]
    args << "--enable-sensors" if OS.linux?
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      htop requires root privileges to correctly display all running processes,
      so you will need to run `sudo htop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
