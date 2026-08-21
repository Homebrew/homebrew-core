class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.sourceforge.net/history.html
  # TODO: Upstream temporarily uses SourceForge due to issues with DreamHost. Check if they resolve this
  url "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-13.55.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-13.55.tar.gz"
  mirror "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-13.55.tar.gz"
  sha256 "5f4c81d34ad406538c2871ad72dbfceb5d9b412b2f16cbbeb4d712d270846667"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 1
  compatibility_version 1
  head "https://git.code.sf.net/p/exiftool/code.git", branch: "master"

  livecheck do
    url "https://exiftool.sourceforge.net/history.html"
    regex(/production\s+release\s+is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/im)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4477e036ab8db27aab707d35d077057d012637290604cd95e0aca0abae28da64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca96e03beb59ea8a21c56d9c952b83d02e0be1deade0e7d44a96c53801978ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1415b75fe1832777026f05301fa89ce434bb19674280a8180f9484f9b639b3ae"
    sha256 cellar: :any_skip_relocation, tahoe:         "0a04ea42c344370d4bdff05f1be014e6b35ef9494421fc703467db4ccdbd5c91"
    sha256 cellar: :any_skip_relocation, sequoia:       "793ade378941a873bffae4db9e488a1e59cefd7ff8197df20bbfb526adf37988"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c04ef21f26cc442b010f5d48053cd4fb0fdf87c1cb0c12da5649c774dadc78"
    sha256 cellar: :any,                 arm64_linux:   "7907dce88555b2a98c1fce6c2525975b5970915005d21f12134764cb8857d301"
    sha256 cellar: :any,                 x86_64_linux:  "bb8eeb6467f5a666187563c43f8e6c482ee019d6574b5592ac2ce5de199a08e4"
  end

  depends_on "cmake" => :build

  uses_from_macos "perl"

  resource "FFI::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/FFI-CheckLib-0.31.tar.gz"
    sha256 "04d885fc377d44896e5ea1c4ec310f979bb04f2f18658a7e7a4d509f7e80bb80"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.50.tar.gz"
    sha256 "ca6e8d7ce7471c2be54e1009f64c367d7ee233a2894cacf52ebe6f53b04e81e5"
  end

  resource "File::chdir" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1011.tar.gz"
    sha256 "31ebf912df48d5d681def74b9880d78b1f3aca4351a0ed1fe3570b8e03af6c79"
  end

  resource "Path::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.150.tar.gz"
    sha256 "ff20713d1a14d257af9c78209001f40dc177e4b9d1496115cbd8726d577946c7"
  end

  resource "Alien::Build" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.84.tar.gz"
    sha256 "8e891fd3acbac39dd8fdc01376b9abff931e625be41e0910ca30ad59363b4477"
  end

  resource "Mozilla::CA" do
    url "https://cpan.metacpan.org/authors/id/L/LW/LWP/Mozilla-CA-20250602.tar.gz"
    sha256 "adeac0752440b2da094e8036bab6c857e22172457658868f5ac364f0c7b35481"
  end

  resource "Sort::Versions" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Sort-Versions-1.62.tar.gz"
    sha256 "bf5f3307406ebe2581237f025982e8c84f6f6625dd774e457c03f8994efd2eaa"
  end

  # 0.10 rejects Homebrew's cmake 4 and falls back to bundled binaries that fail audit/linkage checks.
  resource "Alien::cmake3" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-cmake3-0.08.tar.gz"
    sha256 "93dfb1146f0053ec1ed59558f5f6d8f85d87b822a8433c6485d419c4f0182f1f"
  end

  resource "File::Slurper" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/File-Slurper-0.014.tar.gz"
    sha256 "d5a36487339888c3cd758e648160ee1d70eb4153cacbaff57846dbcefb344b0c"
  end

  resource "IO::Compress::Brotli" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMLEGGE/IO-Compress-Brotli-0.019.tar.gz"
    sha256 "37f40dd7cee44acea26f2f763a773e61d4ec223305ddeeca4612443cbf288fbf"
  end

  def install
    perl_lib = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", perl_lib

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        if r.name == "IO::Compress::Brotli"
          ENV.deparallelize { system "make", "install" }
        else
          system "make", "install"
        end
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "install"

    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "unshift @INC, $incDir;", <<~EOS
      use Config;
      unshift @INC, "#{perl_lib}";
      unshift @INC, "#{perl_lib}/$Config{archname}";
    EOS

    bin.install "exiftool"
    doc.install Dir["html/*"]
    man1.install "blib/man1/exiftool.1"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")

    resource "sunset-logo-jxl" do
      url "https://github.com/libjxl/conformance/blob/5399ecf01e50ec5230912aa2df82286dc1c379c9/testcases/sunset_logo/input.jxl?raw=true"
      sha256 "6617480923e1fdef555e165a1e7df9ca648068dd0bdbc41a22c0e4213392d834"
    end

    resource("sunset-logo-jxl").stage do
      system bin/"exiftool", "-api", "Compress=1", "-Artist=homebrew", "-m", "input.jxl"
      assert_match "BrotliEXIF", shell_output("#{bin}/exiftool -verbose input.jxl")
    end
  end
end
