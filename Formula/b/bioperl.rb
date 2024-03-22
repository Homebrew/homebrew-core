class Bioperl < Formula
  desc "Perl tools for bioinformatics, genomics and life science"
  homepage "https://bioperl.org"
  url "https://cpan.metacpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-1.7.8.tar.gz"
  sha256 "c490a3be7715ea6e4305efd9710e5edab82dabc55fd786b6505b550a30d71738"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 1
  head "https://github.com/bioperl/bioperl-live.git", branch: "master"

  # We specifically match versions with three numeric parts because upstream
  # documentation mentions that release versions have three parts and there are
  # older tarballs with fewer than three parts that we need to omit for version
  # comparison to work correctly.
  livecheck do
    url :stable
    regex(/href=["']?BioPerl[._-]v?(\d+\.\d+\.\d+)(?:\.?_\d+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7347de2dcd6d853ef48f4eaefb19f57965aac806dde9a9e69b0877986ad415d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14640b78f907bc04201e49dc0c2e28627c81f9a0df71b2dec380ac27928ae9bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c8eb6a2300984f14864ded0694167956dbf20514efa7353ef9efa555132ec63"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad6693582068ff397b2a062e0ca52e69760f23ef85d0be9ef2fa4d99fa8570b4"
    sha256 cellar: :any_skip_relocation, ventura:        "019217d9f2eed33a0cc3400d38c03ba2a4e2e986d7e51308a0264c1564be830e"
    sha256 cellar: :any_skip_relocation, monterey:       "735f3fc0ccae053cec535f5374695535f1284d5c4e98035d735b57b10f08183b"
    sha256                               x86_64_linux:   "ffab2601ba841c7a45bb0c5d0c12661a73ee32b0a9079b2715fc838dddec9649"
  end

  depends_on "cpanminus" => :build
  depends_on "pkg-config" => :build
  depends_on "perl"

  uses_from_macos "zlib"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "cpanm", "--self-contained", "-l", libexec, "DBI" unless OS.mac?
    system "cpanm", "--verbose", "--self-contained", "-l", libexec, "."
    bin.env_script_all_files libexec, "PERL5LIB" => ENV["PERL5LIB"]
    libexec.glob("bin/bp_*") do |executable|
      (bin/executable.basename).write_env_script executable, PERL5LIB: ENV["PERL5LIB"]
    end
  end

  test do
    (testpath/"test.fa").write ">homebrew\ncattaaatggaataacgcgaatgg"
    assert_match ">homebrew\nH*ME*REW", shell_output("#{bin}/bp_translate_seq < test.fa")
    assert_match(/>homebrew-100_percent-1\n[atg]/, shell_output("#{bin}/bp_mutate -i test.fa -p 100 -n 1"))
    assert_match "GC content is 0.3750", shell_output("#{bin}/bp_gccalc test.fa")
  end
end
