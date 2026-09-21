class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "https://openargus.org"
  url "https://github.com/openargus/clients/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "c129fd709cb356a6cdc0692062a9cf8bf62bdfeab4026348f61078ab70b4fbcc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21d62844ba630390dcb15070d3fed8a89df2f210e68ffd4829580547420cf7ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7cb061d76e7d9a391b784c38c1761538334fc018dac7ff96dee854f3fc664b3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fdef29925f63d13ec8168c39fef8eab394918b8f28fbc06da709f8f1d3ae1c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f2f1b52e1315dd5fc5fb0583ce11c1a63988dcf528a581b0eac27b65e663d03c"
    sha256 cellar: :any,                 arm64_linux:       "a2e77e088e0efca5a413bb5aab879c7b42db85443a813c60a0d7e7fc5be0e59b"
    sha256 cellar: :any,                 x86_64_linux:      "10282f91f699f84eecac026d5ebdf531b84062be385282f820bcc76567c92700"
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
    ENV.append_to_cflags "-I#{formula_opt_include("libtirpc")}/tirpc" if OS.linux?

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
