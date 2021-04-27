class FreePascal < Formula
  desc "Mature, versatile, open source Pascal compiler"
  homepage "https://www.freepascal.org/"
  url "https://download.sourceforge.net/project/freepascal/Source/3.2.0/fpc-3.2.0.source.tar.gz"
  sha256 "d595b72de7ed9e53299694ee15534e5046a62efa57908314efa02d5cc3b1cf75"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]

  depends_on arch: :x86_64

  uses_from_macos "icu4c"

  resource "ppcx64" do
    url "ftp://ftp.freepascal.org/pub/fpc/dist/3.0.4/bootstrap/x86_64-macosx-10.9-ppcx64.tar.bz2"
    sha256 "0515ad4251c51fa7e5c0ff9b1d90ea50f41530b56276cc72b73798fae437b3b4"
  end

  def install
    resource("ppcx64").stage buildpath
    system "make", "all", "FPC=#{buildpath}/ppcx64", "OPT=-XR#{MacOS.sdk_path}"
    system "make", "install", "FPC=#{buildpath}/ppcx64", "PREFIX=#{prefix}"
    bin.install_symlink lib/"fpc/#{version}/ppcx64"
    share.install Dir[bin/"*.rsj"]
    (share/"doc").install share/"doc/fpc-#{version}" => "free-pascal"
  end

  def post_install
    system bin/"fpcmkcfg", "-o", etc/"fpc.cfg"
    clang_lib = Dir[MacOS::CLT::PKG_PATH + "/usr/lib/clang/*/lib/darwin"].first
    inreplace etc/"fpc.cfg", %r{-Fl/Applications.+$}, "-Fl#{clang_lib}"
  end

  test do
    (testpath/"test.pas").write <<~EOS
      uses cthreads;
      begin
          writeln('hello');
      end.
    EOS

    system "fpc", "test.pas", "-XR#{MacOS.sdk_path}"
    assert_match "hello", shell_output("./test")
  end
end
