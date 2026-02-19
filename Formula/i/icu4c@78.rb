class Icu4cAT78 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-78.2/icu4c-78.2-sources.tgz"
  sha256 "3e99687b5c435d4b209630e2d2ebb79906c984685e78635078b672e03c89df35"
  license "ICU"

  # We allow the livecheck to detect new `icu4c` major versions in order to
  # automate version bumps. To make sure PRs are created correctly, we output
  # an error during installation to notify when a new formula is needed.
  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "09a7b7f48d9545c653c69a5b815dd20688ab5645b42ec54b445197d79643e7d1"
    sha256 cellar: :any,                 arm64_sequoia: "3222838f8607a84d15de1f8a3acada84ff52cfe9854d5dd90c1aa63dfb034f08"
    sha256 cellar: :any,                 arm64_sonoma:  "ebffbf5bdd705b2280389cdd357249b00c7fdd04546c86235fd44f64e0c84a62"
    sha256 cellar: :any,                 sonoma:        "07e6f9e32f5b4a8faea004fd398d15e88b4868f7d524c39bf9d41dcfe08ad649"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2922da686864b89f1667c55132a937376685960de702f7a2399d09061815a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1551d2c21bfc6a1ef4143e41a030c8773eab13821f70491a16025e1419768893"
  end

  keg_only :shadowed_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    odie "Major version bumps need a new formula!" if version.major.to_s != name[/@(\d+)$/, 1]

    args = %w[
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end

    inreplace [bin/"icu-config", *lib.glob("pkgconfig/icu-*.pc")], prefix, opt_prefix
  end

  test do
    if File.exist? "/usr/share/dict/words"
      system bin/"gendict", "--uchars", "/usr/share/dict/words", "dict"
    else
      (testpath/"hello").write "hello\nworld\n"
      system bin/"gendict", "--uchars", "hello", "dict"
    end
  end
end
