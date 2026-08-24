class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/releases/download/3.5.3/htop-3.5.3.tar.xz"
  sha256 "a8b164386494cb85bb255a415a3f5f80afe7a0c4491da5d113b3a0f951087e65"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d57bf20d0cbade0647877bbc74d736e743e050d2c0296b0591c78aa2c70ca516"
    sha256 cellar: :any, arm64_sequoia: "c9f94a86905f32eb73ae3cbfbeef9bb269cdd723f0843a1146b8fb103973421d"
    sha256 cellar: :any, arm64_sonoma:  "76274649e2fe8e65c53c85e8e540aaf759facc6f1629b8f9ff41200f6a8b2b4a"
    sha256 cellar: :any, sonoma:        "598e42a8354e720c30f70d5713d977cf88386379710e7876f9e733ea132c8f98"
    sha256 cellar: :any, arm64_linux:   "5421cf57c0c0ae15422d78a55db4abf72569edad65ebae619e1d652f9e697b46"
    sha256 cellar: :any, x86_64_linux:  "781f9ced3961360377b636cfaa939804b87356364fe928e374288d3e55b5faad"
  end

  head do
    url "https://github.com/htop-dev/htop.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses" # enables mouse scroll

  on_linux do
    depends_on "lm-sensors"
  end

  def install
    system "./autogen.sh" if build.head?
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
    pipe_output(bin/"htop", "q", 0)
  end
end
