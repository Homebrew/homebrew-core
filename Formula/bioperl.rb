class Bioperl < Formula
  desc "Perl tools for bioinformatics, genomics and life science"
  homepage "https://bioperl.org"
  url "https://cpan.metacpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-1.7.8.tar.gz"
  sha256 "c490a3be7715ea6e4305efd9710e5edab82dabc55fd786b6505b550a30d71738"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/bioperl/bioperl-live.git", branch: "master"

  livecheck do
    url :stable
    regex(/href=.*?>BioPerl-(\d+\.\d+\.\d+)\.t/i)
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
