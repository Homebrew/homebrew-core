class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.22.tar.gz"
  sha256 "6945bd3c4aaa83da83d80a045c5563da4edd7d0374c62c0d35aec09eb3014600"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?libtermkey[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "97c29474c42b54cb9784fe05855b969b7fbb3a20e7b46081f257cff2e149dcb9"
    sha256 cellar: :any,                 arm64_big_sur:  "a9e13d645b016b670bb0d9c79928f5344928685f7d358480210f1af8729480e6"
    sha256 cellar: :any,                 monterey:       "542c3e6cab8cf06b848f38f4e0453e000b6507d4fadc1f5e8c7a81916a156e64"
    sha256 cellar: :any,                 big_sur:        "afaf585bd31e32a5fd01a5c16a4c37af9e38524b72e03a76b61038c60f2ed113"
    sha256 cellar: :any,                 catalina:       "293f71f6cb8498f734910ada7ffe4e8e2ea2cb6121455318053d2a5951b272a8"
    sha256 cellar: :any,                 mojave:         "efa6360ccb50275ee143410e57b4ff47b2d6bafd97d6f4feeb3cb3ee02050a2c"
    sha256 cellar: :any,                 high_sierra:    "e3b848de428f811c1879530c043145152bf4b0e599ed642aa2845904d13f7081"
    sha256 cellar: :any,                 sierra:         "3f8ce77603619d85de7127f317e276c0cd38a461c545cafeb7c875e7c89fe467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9ac2c7fc0a6df84b0743233d1ab68984bc398b2c0550a4c61ab01ddfd9bd665"
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "unibilium"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "glib" => :build
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
