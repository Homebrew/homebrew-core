class Bioperl < Formula
  desc "Perl tools for bioinformatics, genomics and life science"
  homepage "https://bioperl.org"
  url "https://cpan.metacpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-1.7.8.tar.gz"
  sha256 "c490a3be7715ea6e4305efd9710e5edab82dabc55fd786b6505b550a30d71738"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 2
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2908dce831726ddab69edcb252b8b45b1d9b4ba2995bbefc6410dea49a6b230e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d44c606e7a067575bfe21428d84fcd57c7e45daa8b2af2a2cf7b6ae766611b0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cce1be0687ce0d7b8cbaaaa2192dcc0ee3e624978c7e5296c2676099fb9c647e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a79018530a34ea3fc2515bf85a4db9ed4379ccf7aeb9ef5d744d5fdb3009596e"
    sha256 cellar: :any_skip_relocation, ventura:       "ff98f524ac97416bd3893e5decb6f4e5deb9340f27fbca59a5b8f231bd800829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14e32e55fcf6f8242d16b3200ca0df932f03752526af6d26c08256f98acbe8d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c28697f03736035682992843bd2dae185e38958cea70dde760636d5fe5661f13"
  end

  depends_on "cpanminus" => :build
  depends_on "pkgconf" => :build
  depends_on "perl"

  uses_from_macos "expat"
  uses_from_macos "libxml2"

  def install
    ENV["ALIEN_INSTALL_TYPE"] = "system"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "cpanm", "--notest", "--self-contained", "--local-lib", libexec, "DBI" unless OS.mac?
    system "cpanm", "--notest", "--self-contained", "--local-lib", libexec, "."
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
