class Libtickit < Formula
  desc "Library for building interactive full-screen terminal programs"
  homepage "https://www.leonerd.org.uk/code/libtickit/"
  url "https://www.leonerd.org.uk/code/libtickit/libtickit-0.4.6.tar.gz"
  sha256 "4af827ba3aeaf591f4364c20d6e31c608e46fa6ada9ef7389ed5fba597f797b8"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?libtickit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f22fdb55d11dfa484d90767cf3f07c18f5ccdcff5daa6fab016f057954b6d2d5"
    sha256 cellar: :any,                 arm64_sequoia: "50d992c4b4e54c4396fe26f3b103d48266caca33b703d26be6c98b8aa7c34b82"
    sha256 cellar: :any,                 arm64_sonoma:  "0a29fb103a60635fd92d5b61aeb3880771391543a248bf739db0f2eabb96129a"
    sha256 cellar: :any,                 sonoma:        "eb3af7695420dac55df6c001b7ad33499becbb371a36771fd593bffb70142235"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c22c2e1fd63e4adc972310f520678704db6518963f9b44dd36dcbbb3bf8351fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "827aef929dfb62b502d153fb1bc6b94459cecc4c760eb6607a244d46bed32d66"
  end

  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libtermkey"
  depends_on "unibilium"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test_libtickit.c").write <<~C
      #include <tickit.h>
      #include <stdio.h>
      int main(void) {
        printf("%d.%d.%d", tickit_version_major(), tickit_version_minor(), tickit_version_patch());
        return 0;
      }
    C

    ENV.append "CFLAGS", "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-ltickit"
    system "make", "test_libtickit"

    assert_equal version.to_s, shell_output("./test_libtickit")
  end
end
