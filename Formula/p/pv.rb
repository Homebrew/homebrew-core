class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.10.5.tar.gz"
  sha256 "ab21b4f8662280646b6a02e1b9f096790918f89c952bbe0d06fef75d3b52fb15"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f309f22e145a6363d5af01ec38016aadc7ea7b9ae2c07ddb703c557bcd1ade32"
    sha256 arm64_sequoia: "43179d4e43abe9d8ec0bca93b9e25f262107f7cc5a7d996b3870ef2624d8cbc9"
    sha256 arm64_sonoma:  "0479752260d1e7fb1f2dda3f7adec447f71233bea499ca29b4acb5fe70735a77"
    sha256 sonoma:        "6c3b9e1445e54e804b4c20ff1cdec774894a056d56a5beb31340cd6c4a05127b"
    sha256 arm64_linux:   "66ae9869504115c75385077cb1f5a4804c3531fc31cde3b2f9ed83bc4c0cb29a"
    sha256 x86_64_linux:  "5c52013320f8b5291a45a846e6e82ad97e8a6f07eabb440ef75d3f11c0f76eea"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
