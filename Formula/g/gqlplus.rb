class Gqlplus < Formula
  desc "Drop-in replacement for sqlplus, an Oracle SQL client"
  homepage "https://gqlplus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gqlplus/gqlplus/1.16/gqlplus-1.16.tar.gz"
  sha256 "9e0071d6f8bc24b0b3623c69d9205f7d3a19c2cb32b5ac9cff133dc75814acdd"
  license "GPL-2.0-only"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9397a0096269caa5527b82304329ef4504f54978ed22d11dc37195f257fba161"
    sha256 cellar: :any,                 arm64_sequoia: "5719e733e973195be06cd616f58b137b773c9758400a1bc1a8ca97fd45461c78"
    sha256 cellar: :any,                 arm64_sonoma:  "1b6af37611ccc2c88e7674688cd36b31c251da4b5e4dd6fdae887e9e3e7bab01"
    sha256 cellar: :any,                 sonoma:        "845e61f2f7c6de88b4f41039a7ef18a3797cef7efba2149f3657394736783519"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05210d4c4ac4aed362c7785a7e469a08e4681d481f74a841ff07c58243e73538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5272f5d4491a19cc28a458707683d33fd98888511fa831d9fa0099d7434b79f"
  end

  # readline's license is incompatible with GPL-2.0-only.
  # We also cannot use macOS libedit as it lacks _history_list
  depends_on "libedit"

  def install
    ENV.append_to_cflags "-I#{Formula["libedit"].opt_libexec}/include"
    ENV.append "LDFLAGS", "-L#{Formula["libedit"].opt_libexec}/lib"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Fix the version
    # Reported 18 Jul 2016: https://sourceforge.net/p/gqlplus/bugs/43/
    inreplace "gqlplus.c",
      "#define VERSION          \"1.15\"",
      "#define VERSION          \"1.16\""

    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gqlplus -h")
  end
end
