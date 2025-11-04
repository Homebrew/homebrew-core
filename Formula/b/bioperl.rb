class Bioperl < Formula
  desc "Perl tools for bioinformatics, genomics and life science"
  homepage "https://bioperl.org"
  url "https://cpan.metacpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-1.7.8.tar.gz"
  sha256 "c490a3be7715ea6e4305efd9710e5edab82dabc55fd786b6505b550a30d71738"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 3
  head "https://github.com/bioperl/bioperl-live.git", branch: "master"

  # We specifically match versions with three numeric parts because upstream
  # documentation mentions that release versions have three parts and there are
  # older tarballs with fewer than three parts that we need to omit for version
  # comparison to work correctly.
  livecheck do
    url :stable
    regex(/href=["']?BioPerl[._-]v?(\d+\.\d+\.\d+)(?:\.?_\d+)?\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37d322cedc377c2a3c9a34a83de2ae93351c8f73d1656daab3a09fddda619c77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e45145efdf9a960ff029e1ae85eb674748286090b4356cbcac2a2dcd218f3748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0855b98104524f572d7905d390b09c380158baa27172afdb8029947dabaeb1c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fea0dc5ebfa54b87c14ae3b92f873e5cf6a7bf4d23b07abbfa110c2611f1b7ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9144102354a8e56e04a9a0bb09c4601248be8d5227732310066e544aa8281eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1db5e85902ffbdf1682881c5fa3c25eb7290e94c818b7f6928413be95b61102b"
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
