class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.17.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.17.tar.xz"
  sha256 "da3a35c50b1e1f8c8fa322d69fa47c9011ce443a8fb8d1d671b1f01b8b0008eb"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "45e30569a906318428642a079e7b528ce7bf4a3093d4bc74b42cfdf465024747" => :big_sur
    sha256 "eb514b632ea6772589c038ee185c1d5f69ad8a828ce7c66b8da4e9a4ec9e1ca6" => :arm64_big_sur
    sha256 "26e1576582cf0be060f656a44dbad2a296fe4ba159e939fa5be627595ee3d53a" => :catalina
    sha256 "d390ddda63284c31d16a93d0af2d6c857798b12704e9eb402411d931aff31ca6" => :mojave
  end

  depends_on "gettext" if Hardware::CPU.intel?

  uses_from_macos "perl"

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    if Hardware::CPU.intel?
      resource("Locale::gettext").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    args = []
    args << "--enable-nls" if Hardware::CPU.intel?

    system "./configure", "--prefix=#{prefix}", *args
    system "make", "install"
    (libexec/"bin").install "#{bin}/help2man"
    (bin/"help2man").write_env_script("#{libexec}/bin/help2man", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    out = if Hardware::CPU.intel?
      shell_output("#{bin}/help2man --locale=en_US.UTF-8 #{bin}/help2man")
    else
      shell_output("#{bin}/help2man #{bin}/help2man")
    end

    assert_match "help2man #{version}", out
  end
end
