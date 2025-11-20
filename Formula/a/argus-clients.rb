class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "https://openargus.org"
  url "https://github.com/openargus/clients/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "c695e69f8cfffcb6ed978f1f29b1292a2638e4882a66ea8652052ba1e42fe8bc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "035cd5d0076a84d0d23c830e19145f66fe895ac6ea078c8f66f301043b74ff11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5f744dae64c30ef8fc60183486410d2d512b83155b70e1fdf2ec85a5de20a4fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a760cca90fd565fd14745b087550293aefa4d2dfabf33be01df96c2b373631af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a92a4ea3c8550c3428ece86db0a5fc5e9b1cfeff7ada32d0f7cd65c5ec2c5c33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84db26da116fab9c66e38bb8732cdc68a9ffc7da8ef2d6014e3919703a522a4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8971b72a53c213e0e42c494c6541414596aa11c86abd0032d0cd375775d093c"
    sha256 cellar: :any_skip_relocation, ventura:        "e9e2edf0a1a0b4e8f6eb0a68b8a4bb3bc9eb091d79fe45b8de822eb5a13bbe18"
    sha256 cellar: :any_skip_relocation, monterey:       "6fc266f5374526ff225dd0fca2645ffe1f445665c3877b6f3a1879db503a00d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "41f00d0bc7f3472d5bf84ebd9756e75f38d7671732ecfef5ee573b27f3cb0fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ab05f0d7461e89b9f7ac1b18c6abb4d191a9c045eaf151d1126eb35f91157c6"
  end

  depends_on "perl"
  depends_on "readline"
  depends_on "rrdtool"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtirpc"
  end

  resource "Switch" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz"
    sha256 "31354975140fe6235ac130a109496491ad33dd42f9c62189e23f49f75f936d75"
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
