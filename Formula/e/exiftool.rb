class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://exiftool.org/Image-ExifTool-13.30.tar.gz"
  mirror "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-13.30.tar.gz"
  sha256 "885afd06c4efcc60d1df703cc88ba7ddc3bb6fed854cfbaa9e6cd72adfbe8da9"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70a143caa51de256d24593c73827e88ef2a11273a9193bf8f8f92d0975b748b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2393c32c588b880d4958673b5039a9fe41999220ba97db8c47bb0453587a7852"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b04c6d4670c42616e68ec0792dbb870eb2818bc140bf8177c13bded37572b9ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "1db3793c461c2e091dec75ac92daaff5583129a7ccd23c066502a6ad366ece2d"
    sha256 cellar: :any_skip_relocation, ventura:       "e176bf7544e0681be10f199c80eba26b5f7576a9c2fc425c785b2eb42648f69f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "706140522b5e03579fd189f8c2b771e46286de3d388c214a188d0ea478bab831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9062b3428cc3c0ab5eec26846c515af95a3327b51db3c5bd03fda8104f78e5c6"
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
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.148.tar.gz"
    sha256 "818aed754b74f399e42c238bea738e20a52af89a6e3feb58bec9d0130eea4746"
  end

  resource "Alien::Build" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.84.tar.gz"
    sha256 "8e891fd3acbac39dd8fdc01376b9abff931e625be41e0910ca30ad59363b4477"
  end

  resource "Mozilla::CA" do
    url "https://cpan.metacpan.org/authors/id/L/LW/LWP/Mozilla-CA-20250202.tar.gz"
    sha256 "32d43ce8cb3b201813898f0c4c593a08df350c1e47484e043fc8adebbda60dbf"
  end

  resource "Sort::Versions" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Sort-Versions-1.62.tar.gz"
    sha256 "bf5f3307406ebe2581237f025982e8c84f6f6625dd774e457c03f8994efd2eaa"
  end

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
