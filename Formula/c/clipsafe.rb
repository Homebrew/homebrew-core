class Clipsafe < Formula
  desc "Command-line interface to Password Safe"
  homepage "https://waxandwane.org/clipsafe.html"
  url "https://waxandwane.org/download/clipsafe-1.1.tar.gz"
  sha256 "7a70b4f467094693a58814a42d272e98387916588c6337963fa7258bda7a3e48"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?clipsafe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fa4d98ac33833ba0514277bb4f653d7591b76d2865f3286bf410f2239e101d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d87595e7a8594b045facd8dc1cdc4d100f9d9c2277147e848cc3c0e30033f1a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f223d8fd1921ec1d70109a252ca7e2d36688eeea7973d596b7926c0a553f14a8"
    sha256 cellar: :any_skip_relocation, ventura:        "1de5ffce74d79f4a439603e76e9f5f85be6271e2b8778bb99d85121a8b6e2f79"
    sha256 cellar: :any_skip_relocation, monterey:       "7c995d83ce5e81f74a1b717a87432246747fb7f94ef8c0847e5c9c1a1d9116a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b949fa30ed125b70558ce545cd24a56094b2cc5cdf8fe722a1f339dedca8a9a"
    sha256 cellar: :any_skip_relocation, catalina:       "771e4477328d156ba6c28dc73c58380f63486ac3f1adc77da6fa4585f2eed925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef98419e5f656879ca819a3b7c87069fbafec8d6dd7890ead046457b04bd8234"
  end

  uses_from_macos "perl"

  on_linux do
    resource "Digest::SHA" do
      url "https://cpan.metacpan.org/authors/id/M/MS/MSHELOR/Digest-SHA-6.02.tar.gz"
      sha256 "2c66a6bea3eac9c210315ac7bf0af3e2e35679c4b65d8bae1ad4be3a58039b06"
    end

    resource "Specio::Exporter" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.47.tar.gz"
      sha256 "f41307f14444f8777e572f27eeb6a964084399e7e382c47c577827ad8a286a1c"
    end

    resource "File::ShareDir::Install" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.13.tar.gz"
      sha256 "45befdf0d95cbefe7c25a1daf293d85f780d6d2576146546e6828aad26e580f9"
    end

    resource "DateTime" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-1.57.tar.gz"
      sha256 "84643299a40f113361a0898e4e636638aa5d7668760047a3cbbcbc4ad57fd86b"
    end

    resource "DateTime::Locale" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.34.tar.gz"
      sha256 "b3c4db7d0afba9762315379f1e64d798ff21fc99f987e8cfedc07a2f7cf20340"
    end

    resource "DateTime::TimeZone" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.52.tar.gz"
      sha256 "8bc5c42082874b0e9c9ef949fa19035ac9b6904ebcda1931aa2d8a13f3950d8f"
    end

    resource "namespace::autoclean" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/namespace-autoclean-0.29.tar.gz"
      sha256 "45ebd8e64a54a86f88d8e01ae55212967c8aa8fed57e814085def7608ac65804"
    end

    resource "namespace::clean" do
      url "https://cpan.metacpan.org/authors/id/R/RI/RIBASUSHI/namespace-clean-0.27.tar.gz"
      sha256 "8a10a83c3e183dc78f9e7b7aa4d09b47c11fb4e7d3a33b9a12912fd22e31af9d"
    end

    resource "B::Hooks::EndOfScope" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/B-Hooks-EndOfScope-0.26.tar.gz"
      sha256 "39df2f8c007a754672075f95b90797baebe97ada6d944b197a6352709cb30671"
    end

    resource "Module::Implementation" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Module-Implementation-0.09.tar.gz"
      sha256 "c15f1a12f0c2130c9efff3c2e1afe5887b08ccd033bd132186d1e7d5087fd66d"
    end

    resource "Module::Runtime" do
      url "https://cpan.metacpan.org/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz"
      sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
      sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
    end

    resource "Variable::Magic" do
      url "https://cpan.metacpan.org/authors/id/V/VP/VPIT/Variable-Magic-0.62.tar.gz"
      sha256 "3f9a18517e33f006a9c2fc4f43f01b54abfe6ff2eae7322424f31069296b615c"
    end

    resource "Sub::Exporter::Progressive" do
      url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
      sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
    end

    resource "Package::Stash" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-0.40.tar.gz"
      sha256 "5a9722c6d9cb29ee133e5f7b08a5362762a0b5633ff5170642a5b0686e95e066"
    end

    resource "Module::Build" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz"
      sha256 "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717"
    end

    resource "Params::Validate" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-Validate-1.30.tar.gz"
      sha256 "9a3a35583d3125d07e8c802c1f92f5be7d526e76dd496e944da270b1e273d812"
    end

    resource "Sub::Identify" do
      url "https://cpan.metacpan.org/authors/id/R/RG/RGARCIA/Sub-Identify-0.14.tar.gz"
      sha256 "068d272086514dd1e842b6a40b1bedbafee63900e5b08890ef6700039defad6f"
    end

    resource "Class::Singleton" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHAY/Class-Singleton-1.6.tar.gz"
      sha256 "27ba13f0d9512929166bbd8c9ef95d90d630fc80f0c9a1b7458891055e9282a4"
    end

    resource "MRO::Compat" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/MRO-Compat-0.15.tar.gz"
      sha256 "0d4535f88e43babd84ab604866215fc4d04398bd4db7b21852d4a31b1c15ef61"
    end

    resource "Role::Tiny" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.002004.tar.gz"
      sha256 "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45"
    end

    resource "Eval::Closure" do
      url "https://cpan.metacpan.org/authors/id/D/DO/DOY/Eval-Closure-0.14.tar.gz"
      sha256 "ea0944f2f5ec98d895bef6d503e6e4a376fea6383a6bc64c7670d46ff2218cad"
    end

    resource "Devel::StackTrace" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.04.tar.gz"
      sha256 "cd3c03ed547d3d42c61fa5814c98296139392e7971c092e09a431f2c9f5d6855"
    end

    resource "Params::ValidationCompiler" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.30.tar.gz"
      sha256 "dc5bee23383be42765073db284bed9fbd819d4705ad649c20b644452090d16cb"
    end

    resource "Exception::Class" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Exception-Class-1.45.tar.gz"
      sha256 "5482a77ef027ca1f9f39e1f48c558356e954936fc8fbbdee6c811c512701b249"
    end

    resource "Class::Data::Inheritable" do
      url "https://cpan.metacpan.org/authors/id/R/RS/RSHERER/Class-Data-Inheritable-0.09.tar.gz"
      sha256 "44088d6e90712e187b8a5b050ca5b1c70efe2baa32ae123e9bd8f59f29f06e4d"
    end

    resource "File::ShareDir" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-ShareDir-1.118.tar.gz"
      sha256 "3bb2a20ba35df958dc0a4f2306fc05d903d8b8c4de3c8beefce17739d281c958"
    end

    resource "Class::Inspector" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Class-Inspector-1.36.tar.gz"
      sha256 "cc295d23a472687c24489d58226ead23b9fdc2588e522f0b5f0747741700694e"
    end
  end

  resource "Crypt::Twofish" do
    url "https://cpan.metacpan.org/authors/id/A/AM/AMS/Crypt-Twofish-2.18.tar.gz"
    sha256 "5881555d6187972a2382aa0d4db2d74c970b06774c621b6ca523739236d2d501"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        if File.exist? "Makefile.PL"
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system "./Build"
          system "./Build", "install"
        end
      end
    end

    bin.install "clipsafe"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system bin/"clipsafe", "--help"
  end
end
