class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://github.com/edbrowse/edbrowse/archive/refs/tags/v3.8.16.tar.gz"
  sha256 "7593e7ebd4ab0cff05c8d1a6cfb72c667a62aaffa2d84e0d4d29b8ab68459d0e"
  license "GPL-2.0-or-later"
  head "https://github.com/edbrowse/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d82e9caa53a4306edf1ed0e546117cf2179fdfa681502ae2b2a32f0e3307cd9"
    sha256 cellar: :any,                 arm64_sequoia: "09f7024c882858624755ed25225a0325a4c3aea8026fc473031830c10d759c41"
    sha256 cellar: :any,                 arm64_sonoma:  "5abb19a1db5e992ffb4ade30a1c0dd6e0badf248c8df67ff345a3566c2a68226"
    sha256 cellar: :any,                 sonoma:        "fa1a0e8cf537963ab2d68728962453403b50f762be723cdf2320d90340cd8255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2875b7495df6a8bdc65c7fec1c1f1788be6b5aa04583703f62358d421dbc8da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58489129de776b9a31a00852fa8e939e29685c2ae857cea281d8c7329044a380"
  end

  depends_on "pkgconf" => :build
  depends_on "quickjs" => :build
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "unixodbc"

  # guard JS_GetVersion for Q_NG builds, upstream pr ref, https://github.com/edbrowse/edbrowse/pull/121
  patch do
    url "https://github.com/edbrowse/edbrowse/commit/fd684cc8bc25376b97ee5ea688ca733ab5ac3564.patch?full_index=1"
    sha256 "3fde047573230d924ca6271c89bed6a1aca3071900bbd53e76e5c8df69aeaded"
  end
  # make install portability fix, upstream pr ref, https://github.com/edbrowse/edbrowse/pull/122
  patch do
    url "https://github.com/edbrowse/edbrowse/commit/e6389a12504d386f97493b91c5f920fafa00c627.patch?full_index=1"
    sha256 "cc30cfe785f138fcc741c3184cbae17a44a7be564442c28ea6821f34687c41fc"
  end

  def install
    ENV.append_to_cflags "-DQ_NG=0"

    cd "src" do
      make_args = [
        "QUICKJS_INCLUDE=#{Formula["quickjs"].opt_include}/quickjs",
        "QUICKJS_LIB=#{Formula["quickjs"].opt_lib}/quickjs",
        "QUICKJS_LIB_NAME=quickjs",
      ]

      system "make", *make_args
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    (testpath/".ebrc").write("")
    (testpath/"test.txt").write("Hello from ed\n")

    system "printf %s\\\\n 's/ed/edbrowse/' 'w' 'q' | #{bin}/edbrowse -c .ebrc test.txt"
    assert_equal "Hello from edbrowse", (testpath/"test.txt").read.chomp
  end
end
