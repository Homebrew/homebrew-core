class Bioperl < Formula
  desc "Perl tools for bioinformatics, genomics and life science"
  homepage "https://bioperl.org"
  url "https://cpan.metacpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-1.7.8.tar.gz"
  sha256 "c490a3be7715ea6e4305efd9710e5edab82dabc55fd786b6505b550a30d71738"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eca523bdef4f935b8887b120307c4841372c1a349d96255cd173fb2bd4ade142"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edad2306b7e911884abc787c59cb8ce91ae5cc59d4fad4373bade3a11fc3806a"
    sha256 cellar: :any_skip_relocation, monterey:       "2e449a33bfdec93ad0429d62ad331d41f3aefc1e7add30daf584518f941fd9a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c876cdb3cc4f70f3251d57fe47c3fbb6ec9a303df8dbaa276f0b8072ca39d1c9"
    sha256 cellar: :any_skip_relocation, catalina:       "631f46b74bf805d23a414d34961f8e14fe2f0be2224522dfe3eb6f73a7adbb0d"
    sha256 cellar: :any_skip_relocation, mojave:         "a284378a572edc991e964002c99b6991d4fb37610dfcd9f6abd8587b16962896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6baaf72a4d61a3e466ecd8c02a2943e3408d880177df58a45279c16bfe72b2f2"
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
