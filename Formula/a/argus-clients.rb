class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "https://openargus.org"
  url "https://github.com/openargus/clients/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "c695e69f8cfffcb6ed978f1f29b1292a2638e4882a66ea8652052ba1e42fe8bc"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e26b45c0acd6b6da44868f99227cea5680806709c2a1fe6765cb75548595e27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa390a8b4e242fb30b0f6cd07d65116b969cfe7416235e76e3396861735a0fb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64cac1f77ccf88c417625996d814055c835049f18228a10a6c10087b93331b08"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6fc9682378acd09e4b37e294a9aa8d61378d7861187fe240187c5f7cb92898c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c0b14a2dd371d30a8a8d9302e820c0dea30e0d0ec8c0ce869094a5f33fbc3e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f91a2424dec64075a85d4c86b849a4e0cdc097a3b1766cd4eca97d96d3e0f525"
  end

  depends_on "readline"
  depends_on "rrdtool"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl"

  on_linux do
    depends_on "libtirpc"
    depends_on "zlib-ng-compat"
  end

  resource "Switch" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz"
    sha256 "31354975140fe6235ac130a109496491ad33dd42f9c62189e23f49f75f936d75"

    livecheck do
      url :url
    end
  end

  def install
    ENV.append_to_cflags "-I#{Formula["libtirpc"].opt_include}/tirpc" if OS.linux?

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV["PERL_EXT_LIB"] = libexec/"lib/perl5"

    system "./configure", "--prefix=#{prefix}", "--without-examples"
    system "make"
    system "make", "install"
  end

  test do
    ENV["PERL5LIB"] = libexec/"lib/perl5"
    system "perl", "-e", "use qosient::util;"

    assert_match "Ra Version #{version}", shell_output("#{bin}/ra -h", 1)
  end
end
