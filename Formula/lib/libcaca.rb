class Libcaca < Formula
  desc "Convert pixel information into colored ASCII art"
  homepage "http://caca.zoy.org/wiki/libcaca"
  url "https://github.com/cacalabs/libcaca/releases/download/v0.99.beta20/libcaca-0.99.beta20.tar.bz2"
  mirror "https://fossies.org/linux/privat/libcaca-0.99.beta20.tar.bz2"
  sha256 "ff9aa641af180a59acedc7fc9e663543fb397ff758b5122093158fd628125ac1"
  license "WTFPL"
  compatibility_version 1

  # Need an explicit livecheck as only beta versions are available
  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1bf1cbd0c20bfcec98baa3baf5c7fbef225c45b96b016a7fe0c4b0aba329ba3f"
    sha256 cellar: :any,                 arm64_sequoia: "73a575ae24fd5a0ef1868a5cbaba6c0e535f3c2b85fbe6763cf9641109a20757"
    sha256 cellar: :any,                 arm64_sonoma:  "dcce30fad2e3096cb10d6c2d74200c51e9637bc5801bc53ae53e0b8359d6db16"
    sha256 cellar: :any,                 sonoma:        "f2a90505005634192a9e683ee0b58072370ffd24147c528662252d511e54cd61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bdbc127aecafd8e35ad5559205e2c0d9ba82b5c1c864e311a881367d46cdf01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14c988337fcd86dc31b0db8009e934c356c795ddf62aea1d1987549bb2f53f6c"
  end

  head do
    url "https://github.com/cacalabs/libcaca.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "imlib2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./bootstrap" if build.head?

    args = %w[
      --disable-cocoa
      --disable-csharp
      --disable-doc
      --disable-java
      --disable-python
      --disable-ruby
      --disable-slang
      --disable-x11
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    ENV.deparallelize # Or install can fail making the same folder at the same time
    system "make", "install"
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    assert_match "\e[0;5;34;44m", shell_output("#{bin}/img2txt test.png")
  end
end
