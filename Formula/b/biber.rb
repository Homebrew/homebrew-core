class Biber < Formula
  desc "Backend processor for BibLaTeX"
  homepage "https://sourceforge.net/projects/biblatex-biber/"
  url "https://github.com/plk/biber/archive/refs/tags/v2.21.tar.gz"
  sha256 "2652cf3ae0abff5fb233aa77f18e70014cc2c70b94a8693c099a3cad9bbb4b20"
  license "Artistic-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "be75b3c9eaecbe7613ecb84f2f7839971d5ac01d8a9ed7059ee6b28194d438c2"
    sha256 cellar: :any,                 arm64_sequoia: "6fc9e838b5322ed36210125d196aae4f67041d65dccab11f4b940aec74e39364"
    sha256 cellar: :any,                 arm64_sonoma:  "961f8c770d7f11db05e006c9337f8dad768edaeb79b7ed6d2e17e6e4bdd83619"
    sha256 cellar: :any,                 sonoma:        "20e097be1791299b36d910b2bb55e96330c2d581961aba453a8bc7e570fc877b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c13171a65288715e776c4b5e7d37081f006cb3ac8b60cf2ad749a409a3fc22e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bb333ed55a8c6d2ee8ccf35b88b876127d2cbd16a591febd666e5aa0527acf6"
  end

  depends_on "pkgconf" => :build
  depends_on "texlive" => :test

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "perl"

  on_linux do
    depends_on "openssl@3"

    resource "Algorithm::Diff" do
      url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Algorithm-Diff-1.201.tar.gz"
      sha256 "0022da5982645d9ef0207f3eb9ef63e70e9713ed2340ed7b3850779b0d842a7d"
    end

    resource "Alien::Build" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.84.tar.gz"
      sha256 "8e891fd3acbac39dd8fdc01376b9abff931e625be41e0910ca30ad59363b4477"
    end

    resource "Alien::Build::Plugin::Download::GitLab" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-Plugin-Download-GitLab-0.01.tar.gz"
      sha256 "c1f089c8ea152a789909d48a83dbfcf2626f773daf30431c8622582b26aba902"
    end

    resource "Alien::Libxml2" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.20.tar.gz"
      sha256 "56aae7b339bbeb02f77c5801f57a821be5791b51f43bf7f9062bb3bfa444c328"
    end

    resource "B::Hooks::EndOfScope" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/B-Hooks-EndOfScope-0.28.tar.gz"
      sha256 "edac77a17fc36620c8324cc194ce1fad2f02e9fcbe72d08ad0b2c47f0c7fd8ef"
    end

    resource "Capture::Tiny" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.50.tar.gz"
      sha256 "ca6e8d7ce7471c2be54e1009f64c367d7ee233a2894cacf52ebe6f53b04e81e5"
    end

    resource "Class::Accessor" do
      url "https://cpan.metacpan.org/authors/id/K/KA/KASEI/Class-Accessor-0.51.tar.gz"
      sha256 "bf12a3e5de5a2c6e8a447b364f4f5a050bf74624c56e315022ae7992ff2f411c"
    end

    resource "Class::Data::Inheritable" do
      url "https://cpan.metacpan.org/authors/id/R/RS/RSHERER/Class-Data-Inheritable-0.10.tar.gz"
      sha256 "aa1ae68a611357b7bfd9a2f64907cc196ddd6d047cae64ef9d0ad099d98ae54a"
    end

    resource "Class::Inspector" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Class-Inspector-1.36.tar.gz"
      sha256 "cc295d23a472687c24489d58226ead23b9fdc2588e522f0b5f0747741700694e"
    end

    resource "Class::Singleton" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHAY/Class-Singleton-1.6.tar.gz"
      sha256 "27ba13f0d9512929166bbd8c9ef95d90d630fc80f0c9a1b7458891055e9282a4"
    end

    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.48.tar.gz"
      sha256 "321d4cd1078e19519600abd7bda2991b468603c58455479e3d2e25a5acb1911f"
    end

    resource "Clone::PP" do
      url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Clone-PP-1.08.tar.gz"
      sha256 "57203094a5d8574b6a00951e8f2399b666f4e74f9511d9c9fb5b453d5d11f578"
    end

    resource "Data::Compare" do
      url "https://cpan.metacpan.org/authors/id/D/DC/DCANTRELL/Data-Compare-1.29.tar.gz"
      sha256 "53c9db3b93263c88aaa3c4072d819eaded024d7a36b38c0c37737d288d5afa8c"
    end

    resource "Data::Dump" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Data-Dump-1.25.tar.gz"
      sha256 "a4aa6e0ddbf39d5ad49bddfe0f89d9da864e3bc00f627125d1bc580472f53fbd"
    end

    resource "DateTime" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-1.66.tar.gz"
      sha256 "afabd686fb83d3ebf49ee453974f9122f3eec9b25ff8d2ddf4f12de92af1e5e2"
    end

    resource "DateTime::TimeZone" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.67.tar.gz"
      sha256 "15df7c1decf2779fded1dda8ad9c3541fe858a7b276b362afb269579fc3d6b84"
    end

    resource "Devel::StackTrace" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.05.tar.gz"
      sha256 "63cb6196e986a7e578c4d28b3c780e7194835bfc78b68eeb8f00599d4444888c"
    end

    resource "Dist::CheckConflicts" do
      url "https://cpan.metacpan.org/authors/id/D/DO/DOY/Dist-CheckConflicts-0.11.tar.gz"
      sha256 "ea844b9686c94d666d9d444321d764490b2cde2f985c4165b4c2c77665caedc4"
    end

    resource "Encode::Locale" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end

    resource "Eval::Closure" do
      url "https://cpan.metacpan.org/authors/id/D/DO/DOY/Eval-Closure-0.14.tar.gz"
      sha256 "ea0944f2f5ec98d895bef6d503e6e4a376fea6383a6bc64c7670d46ff2218cad"
    end

    resource "Exception::Class" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Exception-Class-1.45.tar.gz"
      sha256 "5482a77ef027ca1f9f39e1f48c558356e954936fc8fbbdee6c811c512701b249"
    end

    resource "Exporter::Tiny" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.006003.tar.gz"
      sha256 "6499f09a6432cf87b133fb9580a8a9a9a6c566821346b1fdee95f7b64c0317b1"
    end

    resource "FFI::CheckLib" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/FFI-CheckLib-0.31.tar.gz"
      sha256 "04d885fc377d44896e5ea1c4ec310f979bb04f2f18658a7e7a4d509f7e80bb80"
    end

    resource "File::chdir" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1011.tar.gz"
      sha256 "31ebf912df48d5d681def74b9880d78b1f3aca4351a0ed1fe3570b8e03af6c79"
    end

    resource "File::Find::Rule" do
      url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/File-Find-Rule-0.35.tar.gz"
      sha256 "2bd556289a6d44ad2ee74803258bb0b0050d246f1e81caab0b263c303acf0c82"
    end

    resource "File::Listing" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.16.tar.gz"
      sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
    end

    resource "File::Remove" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/File-Remove-1.61.tar.gz"
      sha256 "fd857f585908fc503461b9e48b3c8594e6535766bc14beb17c90ba58d5dc4975"
    end

    resource "File::ShareDir" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-ShareDir-1.118.tar.gz"
      sha256 "3bb2a20ba35df958dc0a4f2306fc05d903d8b8c4de3c8beefce17739d281c958"
    end

    resource "File::ShareDir::Install" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.14.tar.gz"
      sha256 "8f9533b198f2d4a9a5288cbc7d224f7679ad05a7a8573745599789428bc5aea0"
    end

    resource "File::Which" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
      sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
    end

    resource "HTML::Parser" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.83.tar.gz"
      sha256 "7278ce9791256132b26a71a5719451844704bb9674b58302c3486df43584f8c0"
    end

    resource "HTML::Tagset" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz"
      sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
    end

    resource "HTTP::Cookies" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.11.tar.gz"
      sha256 "8c9a541a4a39f6c0c7e3d0b700b05dfdb830bd490a1b1942a7dedd1b50d9a8c8"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
      sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
    end

    resource "HTTP::Message" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-7.01.tar.gz"
      sha256 "82b79ce680251045c244ee059626fecbf98270bed1467f0175ff5ea91071437e"
    end

    resource "HTTP::Negotiate" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
      sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
    end

    resource "IO::HTML" do
      url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
      sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
    end

    resource "IO::Socket::SSL" do
      url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.098.tar.gz"
      sha256 "b38473be20256b1a06447dd6769ad162bfad6a258234ed2c7e2e1819c16c4df7"
    end

    resource "IO::String" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz"
      sha256 "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0"
    end

    resource "IPC::Run3" do
      url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/IPC-Run3-0.049.tar.gz"
      sha256 "9d048ae7b9ae63871bae976ba01e081d887392d904e5d48b04e22d35ed22011a"
    end

    resource "List::MoreUtils" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz"
      sha256 "63b1f7842cd42d9b538d1e34e0330de5ff1559e4c2737342506418276f646527"
    end

    resource "List::MoreUtils::XS" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz"
      sha256 "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242"
    end

    resource "LWP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.81.tar.gz"
      sha256 "ab30552f194e8b5ae3ac0885132fd1d4ea04c4c7fe6555765b98f01af70c1736"
    end

    resource "LWP::MediaTypes" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
      sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
    end

    resource "LWP::Protocol::https" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.15.tar.gz"
      sha256 "44eec2da147ba0511090871b0ca82f69794376bc31e8c76d1040961ba57f59b8"
    end

    resource "MIME::Base32" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/MIME-Base32-1.303.tar.gz"
      sha256 "ab21fa99130e33a0aff6cdb596f647e5e565d207d634ba2ef06bdbef50424e99"
    end

    resource "Module::Build" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
      sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
    end

    resource "Module::Implementation" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Module-Implementation-0.09.tar.gz"
      sha256 "c15f1a12f0c2130c9efff3c2e1afe5887b08ccd033bd132186d1e7d5087fd66d"
    end

    resource "Module::Install" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Module-Install-1.21.tar.gz"
      sha256 "fbf91007f30565f3920e106055fd0d4287981d5e7dad8b35323ce4b733f15a7b"
    end

    resource "Module::Runtime" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Module-Runtime-0.018.tar.gz"
      sha256 "0bf77ef68e53721914ff554eada20973596310b4e2cf1401fc958601807de577"
    end

    resource "Module::ScanDeps" do
      url "https://cpan.metacpan.org/authors/id/R/RS/RSCHUPP/Module-ScanDeps-1.37.tar.gz"
      sha256 "1f5e119cade1466c39c71e5bc35a8d4f4e672635db03d79a5a0dcf08c4e2b5a3"
    end

    resource "MRO::Compat" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/MRO-Compat-0.15.tar.gz"
      sha256 "0d4535f88e43babd84ab604866215fc4d04398bd4db7b21852d4a31b1c15ef61"
    end

    resource "namespace::autoclean" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/namespace-autoclean-0.31.tar.gz"
      sha256 "d3b32c82e1d2caa9d58b8c8075965240e6cab66ab9350bd6f6bea4ca07e938d6"
    end

    resource "namespace::clean" do
      url "https://cpan.metacpan.org/authors/id/R/RI/RIBASUSHI/namespace-clean-0.27.tar.gz"
      sha256 "8a10a83c3e183dc78f9e7b7aa4d09b47c11fb4e7d3a33b9a12912fd22e31af9d"
    end

    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.24.tar.gz"
      sha256 "290ed9a97b05c7935b048e6d2a356035871fca98ad72c01c5961726adf85c83c"
    end

    resource "Net::SSLeay" do
      url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.94.tar.gz"
      sha256 "9d7be8a56d1bedda05c425306cc504ba134307e0c09bda4a788c98744ebcd95d"
    end

    resource "Number::Compare" do
      url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/Number-Compare-0.03.tar.gz"
      sha256 "83293737e803b43112830443fb5208ec5208a2e6ea512ed54ef8e4dd2b880827"
    end

    resource "Package::Stash" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-0.40.tar.gz"
      sha256 "5a9722c6d9cb29ee133e5f7b08a5362762a0b5633ff5170642a5b0686e95e066"
    end

    resource "Package::Stash::XS" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-XS-0.30.tar.gz"
      sha256 "26bad65c1959c57379b3e139dc776fbec5f702906617ef27cdc293ddf1239231"
    end

    resource "Params::Validate" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-Validate-1.31.tar.gz"
      sha256 "1bf2518ef2c4869f91590e219f545c8ef12ed53cf313e0eb5704adf7f1b2961e"
    end

    resource "Params::ValidationCompiler" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.31.tar.gz"
      sha256 "7b6497173f1b6adb29f5d51d8cf9ec36d2f1219412b4b2410e9d77a901e84a6d"
    end

    resource "Parse::RecDescent" do
      url "https://cpan.metacpan.org/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967015.tar.gz"
      sha256 "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37"
    end

    resource "Path::Tiny" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.150.tar.gz"
      sha256 "ff20713d1a14d257af9c78209001f40dc177e4b9d1496115cbd8726d577946c7"
    end

    resource "Regexp::Common" do
      url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2024080801.tar.gz"
      sha256 "0677afaec8e1300cefe246b4d809e75cdf55e2cc0f77c486d13073b69ab4fbdd"
    end

    resource "Role::Tiny" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.002004.tar.gz"
      sha256 "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45"
    end

    resource "Specio" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.53.tar.gz"
      sha256 "0d0eecfb9e89bd0f5f710fac42e1200a882d513a862f98497eaef5927ac6c183"
    end

    resource "Sub::Exporter::Progressive" do
      url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
      sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
    end

    resource "Sub::Quote" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006009.tar.gz"
      sha256 "967282d54d2d51b198c67935594f93e4dea3e54d1e5bced158c94e29be868a4b"
    end

    resource "Test::Differences" do
      url "https://cpan.metacpan.org/authors/id/D/DC/DCANTRELL/Test-Differences-0.72.tar.gz"
      sha256 "648844b9dcb7dae6f9b5a15c9359d0f09de247a624b65c4620ebff249558f913"
    end

    resource "Test::Fatal" do
      url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Test-Fatal-0.018.tar.gz"
      sha256 "b8d2cccf9ee467271bc478f9cf7eba49545452be9302ae359bc538b8bf687cd6"
    end

    resource "Text::Diff" do
      url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Text-Diff-1.45.tar.gz"
      sha256 "e8baa07b1b3f53e00af3636898bbf73aec9a0ff38f94536ede1dbe96ef086f04"
    end

    resource "Text::Glob" do
      url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/Text-Glob-0.11.tar.gz"
      sha256 "069ccd49d3f0a2dedb115f4bdc9fbac07a83592840953d1fcdfc39eb9d305287"
    end

    resource "Time::Date" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.34.tar.gz"
      sha256 "4571da8fad4393e7051be0098bd3ad028b3c60c2d75adf88b1f81b912154d6d2"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.32.tar.gz"
      sha256 "ef2d6cab0bad18e3ab1c4e6125cc5f695c7e459899f512451c8fa3ef83fa7fc0"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.34.tar.gz"
      sha256 "de64c779a212ff1821896c5ca2bb69e74767d2674cee411e777deea7a22604a8"
    end

    resource "Variable::Magic" do
      url "https://cpan.metacpan.org/authors/id/V/VP/VPIT/Variable-Magic-0.64.tar.gz"
      sha256 "9f7853249c9ea3b4df92fb6b790c03a60680fc029f44c8bf9894dccf019516bd"
    end

    resource "WWW::RobotRules" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
      sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
    end

    resource "XML::LibXML" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0210.tar.gz"
      sha256 "a29bf3f00ab9c9ee04218154e0afc8f799bf23674eb99c1a9ed4de1f4059a48d"
    end

    resource "XML::LibXSLT" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXSLT-2.003000.tar.gz"
      sha256 "7caa5aee72f53be59d8b84eecb6864a07c612a12ea6b27d5c706960edcd54587"
    end

    resource "XML::NamespaceSupport" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz"
      sha256 "47e995859f8dd0413aa3f22d350c4a62da652e854267aa0586ae544ae2bae5ef"
    end

    resource "XML::SAX" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-1.02.tar.gz"
      sha256 "4506c387043aa6a77b455f00f57409f3720aa7e553495ab2535263b4ed1ea12a"
    end

    resource "XML::SAX::Base" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz"
      sha256 "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0"
    end

    resource "XML::Writer" do
      url "https://cpan.metacpan.org/authors/id/J/JO/JOSEPHW/XML-Writer-0.900.tar.gz"
      sha256 "73c8f5bd3ecf2b350f4adae6d6676d52e08ecc2d7df4a9f089fa68360d400d1f"
    end

    resource "XString" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/XString-0.005.tar.gz"
      sha256 "f247f55c19aee6ba4a1ae73c0804259452e02ea85a9be07f8acf700a5138f884"
    end

    resource "YAML::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.76.tar.gz"
      sha256 "a8d584394cf069bf8f17cba3dd5099003b097fce316c31fb094f1b1c171c08a3"
    end
  end

  resource "autovivification" do
    url "https://cpan.metacpan.org/authors/id/V/VP/VPIT/autovivification-0.18.tar.gz"
    sha256 "2d99975685242980d0a9904f639144c059d6ece15899efde4acb742d3253f105"
  end

  resource "Business::ISBN" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Business-ISBN-3.013.tar.gz"
    sha256 "745f1ab95e2b3c638493f3cf9637fb73eed3d4c4c9ccb1a3d50de68c26ec6098"
  end

  resource "Business::ISBN::Data" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Business-ISBN-Data-20260311.001.tar.gz"
    sha256 "070c0768b95dcdbf70f495560eeb3a801ed72944e47d811bf01c2698bca2d013"
  end

  resource "Business::ISMN" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Business-ISMN-1.205.tar.gz"
    sha256 "1c48e9b00bc32578b2176e6f79c4a11713d875befa8fbb7f48b7a9c8172fe8bd"
  end

  resource "Business::ISSN" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Business-ISSN-1.008.tar.gz"
    sha256 "b16b3a1b0e53cd45ed3328906d33ad4d59a13b57abf341424553aecf3e443aac"
  end

  resource "Config::AutoConf" do
    url "https://cpan.metacpan.org/authors/id/A/AM/AMBS/Config-AutoConf-0.320.tar.gz"
    sha256 "bb57a958ef49d3f7162276dae14a7bd5af43fd1d8513231af35d665459454023"
  end

  resource "Data::Uniqid" do
    url "https://cpan.metacpan.org/authors/id/M/MW/MWX/Data-Uniqid-0.12.tar.gz"
    sha256 "b6919ba49b9fe98bfdf3e8accae7b9b7f78dc9e71ebbd0b7fef7a45d99324ccb"
  end

  resource "DateTime::Calendar::Julian" do
    url "https://cpan.metacpan.org/authors/id/W/WY/WYANT/DateTime-Calendar-Julian-0.107.tar.gz"
    sha256 "fcb2b424844bb13bcad46b1c7aa239b5a09bab2556f53bd1f27fad90c260d33d"
  end

  resource "DateTime::Format::Builder" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Format-Builder-0.83.tar.gz"
    sha256 "61ffb23d85b3ca1786b2da3289e99b57e0625fe0e49db02a6dc0cb62c689e2f2"
  end

  resource "DateTime::Format::Strptime" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Format-Strptime-1.80.tar.gz"
    sha256 "efe5e2be70425efc123a4e57f4b96b2d23beb03200c8326495b5b433b6b77158"
  end

  resource "DateTime::Locale" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.45.tar.gz"
    sha256 "1bc56dc2ff4b3152612e1d474ca65071ae2c00912e3fa4bc6f5a99e5e7a1da68"
  end

  resource "Encode::EUCJPASCII" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/Encode-EUCJPASCII-0.03.tar.gz"
    sha256 "f998d34d55fd9c82cf910786a0448d1edfa60bf68e2c2306724ca67c629de861"
  end

  resource "Encode::HanExtra" do
    url "https://cpan.metacpan.org/authors/id/A/AU/AUDREYT/Encode-HanExtra-0.23.tar.gz"
    sha256 "1fd4b06cada70858003af153f94c863b3b95f2e3d03ba18d0451a81d51db443a"
  end

  resource "Encode::JIS2K" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DANKOGAI/Encode-JIS2K-0.05.tar.gz"
    sha256 "022f1f3d6869742b3718c27bfcca6f7c96aceffac0a2267d140bbf653d7c0ac2"
  end

  resource "ExtUtils::LibBuilder" do
    url "https://cpan.metacpan.org/authors/id/A/AM/AMBS/ExtUtils-LibBuilder-0.09.tar.gz"
    sha256 "dbfac85d015874189a704fa0a2f001d13b5a0c7d89f36c06ff32d569720a6cfb"
  end

  resource "File::Slurper" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/File-Slurper-0.014.tar.gz"
    sha256 "d5a36487339888c3cd758e648160ee1d70eb4153cacbaff57846dbcefb344b0c"
  end

  resource "Lingua::Translit" do
    url "https://cpan.metacpan.org/authors/id/A/AL/ALINKE/Lingua-Translit-0.29.tar.gz"
    sha256 "1ad2fabc0079dad708b7d9d55437c9ebb192e610bf960af25945858b92597752"
  end

  resource "List::AllUtils" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/List-AllUtils-0.19.tar.gz"
    sha256 "30a8146ab21a7787b8c56d5829cf9a7f2b15276d3b3fca07336ac38d3002ffbc"
  end

  resource "List::SomeUtils" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/List-SomeUtils-0.59.tar.gz"
    sha256 "fab30372e4c67bf5a46062da38d1d0c8756279feada866eb439fa29571a2dc7b"
  end

  resource "List::SomeUtils::XS" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/List-SomeUtils-XS-0.58.tar.gz"
    sha256 "4f9e4d2622481b79cc298e8e29de8a30943aff9f4be7992c0ebb7b22e5b4b297"
  end

  resource "List::Util" do
    on_macos do
      url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.70.tar.gz"
      sha256 "e0cc03f9fe3565cdf4d6102654f87bba3bca2d8ff989da38307e857d0ae3c886"
    end
  end

  resource "List::UtilsBy" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/List-UtilsBy-0.12.tar.gz"
    sha256 "fff1281fd469fe982b1a58044becfd970f313bff3a26e1c7b2b3f4c0a5ed71e0"
  end

  resource "Log::Log4perl" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/Log-Log4perl-1.57.tar.gz"
    sha256 "0f8fcb7638a8f3db4c797df94fdbc56013749142f2f94cbc95b43c9fca096a13"
  end

  resource "MIME::Charset" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/MIME-Charset-1.013.1.tar.gz"
    sha256 "1bb7a6e0c0d251f23d6e60bf84c9adefc5b74eec58475bfee4d39107e60870f0"
  end

  resource "Mozilla::CA" do
    url "https://cpan.metacpan.org/authors/id/L/LW/LWP/Mozilla-CA-20250602.tar.gz"
    sha256 "adeac0752440b2da094e8036bab6c857e22172457658868f5ac364f0c7b35481"
  end

  resource "PerlIO::utf8_strict" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/PerlIO-utf8_strict-0.010.tar.gz"
    sha256 "bcd2848b72df290b5e984fae8b1a6ca96f6d072003cf222389a8c9e8e1c570cd"
  end

  resource "Sort::Key" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SALVA/Sort-Key-1.33.tar.gz"
    sha256 "ed6a4ccfab094c9cd164f564024e98bd21d94f4312ccac4d6246d22b34081acf"
  end

  resource "Text::BibTeX" do
    url "https://cpan.metacpan.org/authors/id/A/AM/AMBS/Text-BibTeX-0.91.tar.gz"
    sha256 "3f0113cf8fe71dc7484636dc8e2a581637ecbcc82d0be29bbd46d0bf3f8cdb37"
  end

  resource "Text::CSV" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/Text-CSV-2.06.tar.gz"
    sha256 "dfcaec925a788b0ba41e51bc6d16e21b0e98b4c7af9b79395090add75f5e506f"
  end

  resource "Text::CSV_XS" do
    url "https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/Text-CSV_XS-1.61.tgz"
    sha256 "2cb9151e8c093921ff68ab9e5c376f7be014a0cb139342f0c3229ac5cdd9fc3a"
  end

  resource "Text::Roman" do
    url "https://cpan.metacpan.org/authors/id/S/SY/SYP/Text-Roman-3.5.tar.gz"
    sha256 "cb4a08a3b151802ffb2fce3258a416542ab81db0f739ee474a9583ffb73e046a"
  end

  resource "Tie::Cycle" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Tie-Cycle-1.233.tar.gz"
    sha256 "043d0bef0afba404eaff236a400a17265cbb609aa2112743212e1f9ee29039f1"
  end

  resource "Unicode::LineBreak" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end

  resource "XML::LibXML::Simple" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/XML-LibXML-Simple-1.01.tar.gz"
    sha256 "cd98c8104b70d7672bfa26b4513b78adf2b4b9220e586aa8beb1a508500365a6"
  end

  def install
    ENV["ALIEN_INSTALL_TYPE"] = "system"
    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix
    ENV["PERL_MM_USE_DEFAULT"] = "1"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"
    runtime_perl5lib = ENV["PERL5LIB"]

    # Help find Encode/encode.h in macOS perl
    if OS.mac?
      perl_privlib = Utils.safe_popen_read("perl", "-MConfig", "-e", "print $Config{privlib}")
      ENV.append_path "PERL5LIB", File.join(MacOS.sdk_path, perl_privlib)
    end

    # Resources that must be installed earlier as they are needed to build other resources
    start_with_resources = %w[
      Capture::Tiny
      File::chdir
      File::Which
      Path::Tiny
      URI
      XML::SAX::Base
      YAML::Tiny
    ]

    all_resources = resources.map(&:name)
    all_resources = (start_with_resources & all_resources) | all_resources
    all_resources.each do |r_name|
      resource(r_name).stage do
        # fix libbtparse.so linkage failure on Linux
        if r_name == "Text::BibTeX" && OS.linux?
          inreplace "inc/MyBuilder.pm", "-lbtparse", "-Wl,-rpath,#{libexec}/lib -lbtparse"
        end

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

    system "perl", "Build.PL", "--install_base", libexec,
                               "--install_path", "script=#{bin}",
                               "--install_path", "bindoc=#{man1}"
    system "./Build"
    system "./Build", "install"
    bin.env_script_all_files libexec/"bin", PERL5LIB: runtime_perl5lib
    (pkgshare/"test").install "t/tdata/annotations.bcf", "t/tdata/annotations.bib"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/biber --version")

    cp (pkgshare/"test").children, testpath
    output = shell_output("#{bin}/biber --validate-control --convert-control annotations")
    assert_match "Output to annotations.bbl", output
    assert_path_exists testpath/"annotations.bcf.html"
    assert_path_exists testpath/"annotations.blg"
    assert_path_exists testpath/"annotations.bbl"

    (testpath/"test.bib").write <<~BIBTEX
      @book{test,
        author = {Test},
        title = {Test}
      }
    BIBTEX
    (testpath/"test.latex").write <<~'LATEX'
      \documentclass{article}
      \usepackage[backend=biber]{biblatex}
      \bibliography{test}
      \begin{document}
      \cite{test}
      \printbibliography
      \end{document}
    LATEX
    system Formula["texlive"].bin/"pdflatex", "-interaction=errorstopmode", testpath/"test.latex"
    system bin/"biber", "test"
    assert_path_exists testpath/"test.bbl"
  end
end
