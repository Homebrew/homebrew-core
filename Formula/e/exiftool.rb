class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://exiftool.org/Image-ExifTool-13.44.tar.gz"
  mirror "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-13.44.tar.gz"
  sha256 "59a762acd704f045a0f5ad5e5ba5d8ef05138fcc027840665a312103c7c02111"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 1

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b6c2148d16f0fe6143ef7ccf022048610d2aa7cabbe4a40993c5284518c5b67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a448201429f1bdb0ed362bf1c3c8408c0d9284f16ec36eca711a83204c4562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd24055659f9ba8fc97cb1ffbae507b204f79b6a432a475f1edffb33f0e40f91"
    sha256 cellar: :any_skip_relocation, tahoe:         "245ed9b709ecca21684f192923b945a56ead8d81fcb9bc8ffdf3b96bfaeb97c2"
    sha256 cellar: :any_skip_relocation, sequoia:       "a4e93002817b031d5a5aa696c9fe8ecd52695410eb29ca5aef74b2890377b879"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a8f60fbae49ba726e86ec7f8242a7deb7f4ece22374dc77e10d37694b3b5816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a2705bdc753a5edf3176b5eb2ce622c7f39dc608ea47895bb4ebe4ad8e46ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "189fc8c7bdcf19943eb437efbf9987cbcb43a1cfff922248228b82a7376fa1ec"
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
