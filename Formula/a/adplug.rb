class Adplug < Formula
  desc "Free, hardware independent AdLib sound player library"
  homepage "https://adplug.github.io"
  url "https://github.com/adplug/adplug/releases/download/adplug-2.4/adplug-2.4.tar.bz2"
  sha256 "de18463bf7c0cb639a3228ad47e69eb7f78a5a197802d325f3a5ed7e1c56d57f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "892435c5c1e839118883ea1ccb12ba98ca1e5ad200523547d63bebabaf1b2b64"
    sha256 cellar: :any,                 arm64_sequoia: "367afb14f5af6fc67209b806c5d6b48bc5b39b45d6981914357f50cfb99e9a88"
    sha256 cellar: :any,                 arm64_sonoma:  "d4cc6d03f6820bab04347eed81792a56670a7b15aacc2cab57bf752e5685d55c"
    sha256 cellar: :any,                 arm64_ventura: "cf6008d2cedfe92a81e66895841c5c0fa47c0807849c4f970a184012e5101d32"
    sha256 cellar: :any,                 sonoma:        "988cd421d220bba2933a2bba81df367e3a5cb6e64fdb02272a9532eadc51cd07"
    sha256 cellar: :any,                 ventura:       "e969b8061a3f8f10218e284760970bffbf963edd9d9c9ee1fbd98cf017aa5d71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4686e12a33772cc5af4303f201c88c59f2417e15e2189afeddaa10c78548976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c16d651b0aff495078228866958b6a7a6d85c2006808b4393afa947a48e72a81"
  end

  head do
    url "https://github.com/adplug/adplug.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libbinio"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    # Workaround for arm64 linux, issue ref: https://github.com/adplug/adplug/issues/246
    ENV.append_to_cflags "-fsigned-char" if OS.linux? && Hardware::CPU.arm?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    resource "ksms" do
      url "http://advsys.net/ken/ksmsongs.zip"
      sha256 "2af9bfc390f545bc7f51b834e46eb0b989833b11058e812200d485a5591c5877"
    end

    resource("ksms").stage do
      (testpath/".adplug").mkpath
      system bin/"adplugdb", "-v", "add", "JAZZSONG.KSM"
    end
  end
end
