class NotmuchMutt < Formula
  desc "Notmuch integration for Mutt"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.40.tar.xz"
  sha256 "4b4314bbf1c2029fdf793637e6c7bb15c1b1730d22be9aa04803c98c5bbc446f"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    formula "notmuch"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "416cbe715372f285c5aefc891c5e262bb8013d7edfd453030d94a24a686c31b6"
    sha256 cellar: :any,                 arm64_sequoia: "77085ee9f759b4139b8d2745f65fa461b98764d6398140ed4d6e993571e0d953"
    sha256 cellar: :any,                 arm64_sonoma:  "db4f899114fb9ffff3df3f26efcad73b6c12c71b54f030fe8068ad478e16ed20"
    sha256 cellar: :any,                 sonoma:        "cafa1e87b69bfc80ecb950fad01dedbebd44b9e2f6986d1838667509e6446ed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c011d1c128f855ca6ef81f325e31f499cfd821c8e3deb4701ec1e34630cd0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e0c078f57da841c53e682927afc5603b81be7099c03676de0c08c18c9f844b4"
  end

  depends_on "notmuch"
  depends_on "readline"

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_linux do
    # macOS perl has Mail::Header
    resource "Mail::Header" do
      url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MailTools-2.22.tar.gz"
      sha256 "3bf68bb212298fa699a52749dddff35583a74f36a92ca89c843b854f29d87c77"
    end

    # macOS perl has following dependencies of Mail::Box
    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.47.tar.gz"
      sha256 "4c2c0cb9a483efbf970cb1a75b2ca75b0e18cb84bcb5c09624f86e26b09c211d"
    end

    resource "Date::Format" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
      sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
    end

    resource "Devel::GlobalDestruction" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Devel-GlobalDestruction-0.14.tar.gz"
      sha256 "34b8a5f29991311468fe6913cadaba75fd5d2b0b3ee3bb41fe5b53efab9154ab"
    end

    resource "Encode::Locale" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end

    resource "File::Remove" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/File-Remove-1.61.tar.gz"
      sha256 "fd857f585908fc503461b9e48b3c8594e6535766bc14beb17c90ba58d5dc4975"
    end

    resource "HTML::Entities" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.83.tar.gz"
      sha256 "7278ce9791256132b26a71a5719451844704bb9674b58302c3486df43584f8c0"
    end

    resource "HTML::Tagset" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz"
      sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
      sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
    end

    resource "HTTP::Headers" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-7.01.tar.gz"
      sha256 "82b79ce680251045c244ee059626fecbf98270bed1467f0175ff5ea91071437e"
    end

    resource "IO::HTML" do
      url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
      sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
    end

    resource "IO::Scalar" do
      url "https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/IO-Stringy-2.113.tar.gz"
      sha256 "51220fcaf9f66a639b69d251d7b0757bf4202f4f9debd45bdd341a6aca62fe4e"
    end

    resource "LWP::MediaTypes" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
      sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
    end

    resource "MIME::Base32" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/MIME-Base32-1.303.tar.gz"
      sha256 "ab21fa99130e33a0aff6cdb596f647e5e565d207d634ba2ef06bdbef50424e99"
    end

    resource "Module::Build" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
      sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
    end

    resource "Sub::Exporter::Progressive" do
      url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
      sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.34.tar.gz"
      sha256 "de64c779a212ff1821896c5ca2bb69e74767d2674cee411e777deea7a22604a8"
    end
  end

  # Mail::Box dependency and recursive dependencies
  resource "Mail::Box" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Box-4.01.tar.gz"
    sha256 "ad66807dd830371278c7fc31f3df9048c16ce9d01430d5fb4414feae05f1fe0d"
  end

  resource "Hash::Case" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Hash-Case-1.07.tar.gz"
    sha256 "f591db9f9a8355c67fba94ae27e06e6339b800ca78c5250d75c7688c0bc33969"
  end

  resource "Hash::Ordered" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Hash-Ordered-0.014.tar.gz"
    sha256 "8dc36cd79155ae37ab8a3de5fd9120ffba9a31e409258c28529ec5251c59747b"
  end

  resource "Log::Report" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Log-Report-1.44.tar.gz"
    sha256 "f747e6575fc68f5811b655ee51674593ff9e90f6016142f2764a8cd3f0ef4fc9"
  end

  resource "Log::Report::Optional" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Log-Report-Optional-1.08.tar.gz"
    sha256 "77b248d4cf7fecaa7e865930e72df0b9d5b333358d00c5bd45e2c71d5df113ad"
  end

  resource "Mail::Message" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Message-4.04.tar.gz"
    sha256 "9915db17c3e0deb4ff4c9065dc2eaf1d3833096937a0d46e573f6f2a76158c54"
  end

  resource "Mail::Transport" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Transport-4.01.tar.gz"
    sha256 "4f851490896f3dc65d9e508cada22a9939cc45dbadb1597612a406a61e7624d2"
  end

  resource "MIME::Charset" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/MIME-Charset-1.013.1.tar.gz"
    sha256 "1bb7a6e0c0d251f23d6e60bf84c9adefc5b74eec58475bfee4d39107e60870f0"
  end

  resource "MIME::Types" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MIME-Types-2.30.tar.gz"
    sha256 "f31b1666bdf420b4b65c373ce0129ee349dd24bab4cd16c7f01b698fe450be6f"
  end

  resource "Object::Realize::Later" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Object-Realize-Later-4.00.tar.gz"
    sha256 "c4753d5a35f147eede09cdbd5e6d627dde3bdaaabfe9e56f2cff72b72d19979b"
  end

  resource "String::Print" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/String-Print-1.02.tar.gz"
    sha256 "3049536486459e38e1d791c07ce022326a91a302beaf01dcdb0e7b703a5da6cc"
  end

  resource "Unicode::GCString" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end

  resource "User::Identity" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/User-Identity-4.00.tar.gz"
    sha256 "46ec55c4b2c158fb9e3bd5c63aaa10695fee8508ef4ec958774dd8eaccab3847"
  end

  # Term::ReadLine::Gnu dependency
  resource "Term::ReadLine::Gnu" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.47.tar.gz"
    sha256 "3b07ac8a9b494c50aa87a40dccab3f879b92eb9527ac0f2ded5d4743d166b649"
  end

  def install
    system "make", "V=1", "prefix=#{prefix}", "-C", "contrib/notmuch-mutt", "install"

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["PERL_MM_USE_DEFAULT"] = "1"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system bin/"notmuch-mutt", "search", "Homebrew"
  end
end
