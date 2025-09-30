class Imake < Formula
  desc "Build automation system written for X11"
  homepage "https://xorg.freedesktop.org"
  url "https://xorg.freedesktop.org/releases/individual/util/imake-1.0.10.tar.xz"
  sha256 "75decbcea8d7b354cf36adc9675e53c4790ee3de56a14bd87b42c8e8aad2ecf5"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?imake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "627e80ff4e32522a945b7f3cc0fb89d5103a8d1b8ee325df80c399f33155f521"
    sha256 arm64_sequoia:  "7ec67382a8dbee7134f20cacb6f701e780ce5e0da7902341047bfcff4492c9e2"
    sha256 arm64_sonoma:   "2e5e51212893abfdefa9fe94309a52728693418424af70ad64424974816d1624"
    sha256 arm64_ventura:  "1bf5d0e8b8fc5f7030162a29d9054863f2af080a8ec62db87d8f6ce90c55d8d6"
    sha256 arm64_monterey: "5708253a196811ca791e556e6b22582b84b8f925d15b2bccca6d13b9f049002b"
    sha256 sonoma:         "f2362816e0e06c863938298689c9cc9b9ee34ffe2aace4369fd42774ab5a66a4"
    sha256 ventura:        "d62ef9dabad43d8c1bf7ee4d40762bf36dab9475ddcbfaf205f67303e3b197b5"
    sha256 monterey:       "b288cbb7cb8faf0e38bd79cae80e0a9b47eebd3e760caaae129aaa001d880fc1"
    sha256 arm64_linux:    "4ba1ca704e4e9383f470dba78fefde5e6eacf51384aecc964221055e36ced4b1"
    sha256 x86_64_linux:   "296155e61983cc533d3f5ab094d796d2ab3d992606be73da1f7a51f3920ea41e"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "tradcpp"

  resource "xorg-cf-files" do
    url "https://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.8.tar.xz"
    sha256 "7408955defcfab0f44d1bedd4ec0c20db61914917ad17bfc1f1c9bf56acc17b9"
  end

  def install
    ENV.deparallelize

    # imake runtime is broken when used with clang's cpp
    cpp_program = Formula["tradcpp"].opt_bin/"tradcpp"
    (buildpath/"imakemdep.h").append_lines <<~C
      #define DEFAULT_CPP "#{cpp_program}"
      #undef USE_CC_E"
    C

    inreplace "imake.man", /__cpp__/, cpp_program

    # also use gcc's cpp during buildtime to pass ./configure checks
    ENV["RAWCPP"] = cpp_program

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"

    resource("xorg-cf-files").stage do
      # Fix for different X11 locations.
      inreplace "X11.rules", "define TopXInclude	/**/",
                "define TopXInclude	-I#{HOMEBREW_PREFIX}/include"
      system "./configure", "--with-config-dir=#{lib}/X11/config",
                            "--prefix=#{HOMEBREW_PREFIX}"
      system "make", "install"
    end
  end

  test do
    # Use pipe_output because the return code is unimportant here.
    output = pipe_output("#{bin}/imake -v -s/dev/null -f/dev/null -T/dev/null 2>&1")
    assert_match "#{Formula["tradcpp"].opt_bin}/tradcpp", output
  end
end
