class Bioperl < Formula
  desc "Perl tools for bioinformatics, genomics and life science"
  homepage "https://bioperl.org"
  url "https://cpan.metacpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-1.7.8.tar.gz"
  sha256 "c490a3be7715ea6e4305efd9710e5edab82dabc55fd786b6505b550a30d71738"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 4
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17405e0b0b17e484a222e76279b4b9732b3d1010f0ef33a05552d8ee4cec1272"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61acb5dde612cf25bbc0f07789dc4275f0b630f09c3b264c36e1d015f8b9eb52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc1d1db579a29a458201328a3607ab29ed9ad2702fbece0f6f3152f32614c5b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b8c427638890704e973ffabfaedf465c9f26da45019d3b0a06a0ed35982d804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55291459382b946db20a86f1dc47d828263b2cb79470351fe18a3396880db4d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c47f38eb54d21c53685df9838272b3cc06a7ded2ec3c51a3a6a75160a3c0abcf"
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
