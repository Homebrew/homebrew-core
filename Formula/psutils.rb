class Psutils < Formula
  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://github.com/rrthomas/psutils/releases/download/v2.10/psutils-2.10.tar.gz"
  sha256 "6f8339fd5322df5c782bfb355d9f89e513353220fca0700a5a28775404d7e98b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9b89051d48565b81d2ae01efa3828ce26407bc69f5f29a8a6a4060fa7621731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "556b035c68743567c8187540e71921c2f465f28c123ccb65e2c28887f51e35e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb8fd5d28221639fc520c12e6461aae0d6bc483af2a5271c56759f6317972aa4"
    sha256 cellar: :any_skip_relocation, ventura:        "0aa8f7945faa119806042db4a106bd7f13371ce1449480e3937c4c67d2bb9c88"
    sha256 cellar: :any_skip_relocation, monterey:       "4869d257409949b9da3f7c5fa3b965cb568d25d15459d9c45f08c651359d0d6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "82ec97f61109e089e1f5fec652a5f968a94fa8ce8f71760a6d2cba9e80d44b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f1a95f218ba372f80656b83ba4b1ff3103eedf6abc6050a3f692ce5473e2a3"
  end

  depends_on "libpaper"

  uses_from_macos "perl"

  resource "IPC::Run3" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/IPC-Run3-0.048.tar.gz"
      sha256 "3d81c3cc1b5cff69cca9361e2c6e38df0352251ae7b41e2ff3febc850e463565"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resource("IPC::Run3").stage do
        system "perl", "Makefile.PL", "INSTALLSITELIB=#{pkgshare}"
        system "make"
        system "make", "install"
      end
    end

    system "./configure", *std_configure_args
    system "make", "install"
    pkgshare.install "tests/psbook-3-input.ps"
  end

  test do
    test_ps = pkgshare/"psbook-3-input.ps"
    system bin/"psbook", test_ps, "test.ps"
    system bin/"psnup", "-n", "2", test_ps, "nup.ps"
    system bin/"psselect", "-p1", test_ps, "test2.ps"
  end
end
