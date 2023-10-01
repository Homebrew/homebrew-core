class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.49.3.tar.xz"
  sha256 "4d7e4fdef2eca6afe07a2682151cea78781e0a4e8f9622142d9f70c083a2fd4f"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6e0e054553f047c31cdfe90cf4e8fa79c4454b85f50652a8446f4855b4cb0a96"
    sha256 cellar: :any,                 arm64_ventura:  "ce35577716d9a055e403e65e2c2c13171820cac8bfdb0e366fba51ba633fe9bb"
    sha256 cellar: :any,                 arm64_monterey: "de3584ad8112414015cc277926be6307cfdc4169d71c57c43f7d65e0b000b57e"
    sha256 cellar: :any,                 arm64_big_sur:  "7f62a4c96936f3b8ed5c9c59f0906f4c3f3574b809989a9b272d743c5ec13374"
    sha256 cellar: :any,                 sonoma:         "c8ed0f64b1210587cc293ddae576f763c60b055cfcae66dfef7ae9cfdff2edeb"
    sha256 cellar: :any,                 ventura:        "0e51ad46b9ede5dd5a26d9c7c4da6a142717e3aaf411bed86b3bfa39180960ab"
    sha256 cellar: :any,                 monterey:       "c472d37b92dc138e948afe53f4f54bb102dc48e613a7ed82e7a81e633a50d189"
    sha256 cellar: :any,                 big_sur:        "03a4d9f94c6ad34b663e0a08cb66e436e672f0842479dcecc6bd60733a383e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "277a57825c150e4b81ec2fb17e1df684cc271140d920f02d15b0a0dfe482213b"
  end

  depends_on "gettext"
  depends_on "perl"

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("Locale::gettext").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "NO_MYMETA=1"
      system "make", "install"
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
    out = shell_output("#{bin}/help2man --locale=en_US.UTF-8 #{bin}/help2man")

    assert_match "help2man #{version}", out
  end
end
