class Biber < Formula
  desc "Backend processor for BibLaTeX"
  homepage "https://sourceforge.net/projects/biblatex-biber/"
  url "https://github.com/plk/biber/archive/refs/tags/v2.21.tar.gz"
  sha256 "2652cf3ae0abff5fb233aa77f18e70014cc2c70b94a8693c099a3cad9bbb4b20"
  license "Artistic-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65fc8db1fa5c46ef2e9e5401156eb28d4fad1fe9e0eceb68d02b750c96155155"
    sha256 cellar: :any,                 arm64_sequoia: "a0534e533cb1cb3efab83beb9e490e1cbda2edcbefbc9a6d155928dff1cf6ed6"
    sha256 cellar: :any,                 arm64_sonoma:  "c30d53b0f2cffb976884b4e012c9f895d0f0e9f352c38a35df1220bc19c35f74"
    sha256 cellar: :any,                 sonoma:        "bb9b06e81a0fa14b97756dd59ad12c6256962e02ef0376442d0776875e9c929b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02274a29fdc128ff74ca9174748d7e8f7ea6e912f8fe6551eba92762b25b904a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3143976c058559944a729ec69819adddc3be6868fed83a0f2739dbe32c096d66"
  end

  depends_on "pkgconf" => :build
  depends_on "texlive" => :test
  depends_on "openssl@3"
  depends_on "perl"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
    sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
  end

  resource "ExtUtils::Config" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Config-0.010.tar.gz"
    sha256 "82e7e4e90cbe380e152f5de6e3e403746982d502dd30197a123652e46610c66d"
  end

  resource "ExtUtils::Helpers" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.028.tar.gz"
    sha256 "c8574875cce073e7dc5345a7b06d502e52044d68894f9160203fcaab379514fe"
  end

  resource "ExtUtils::InstallPaths" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.014.tar.gz"
    sha256 "ae65d20cc3c7e14b3cd790915c84510f82dfb37a4c9b88aa74b2e843af417d01"
  end

  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.052.tar.gz"
    sha256 "bd10452c9f24d4b4fe594126e3ad231bab6cebf16acda40a4e8dc784907eb87f"
  end

  resource "YAML::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.76.tar.gz"
    sha256 "a8d584394cf069bf8f17cba3dd5099003b097fce316c31fb094f1b1c171c08a3"
  end

  resource "Module::ScanDeps" do
    url "https://cpan.metacpan.org/authors/id/R/RS/RSCHUPP/Module-ScanDeps-1.37.tar.gz"
    sha256 "1f5e119cade1466c39c71e5bc35a8d4f4e672635db03d79a5a0dcf08c4e2b5a3"
  end

  resource "File::Remove" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/File-Remove-1.61.tar.gz"
    sha256 "fd857f585908fc503461b9e48b3c8594e6535766bc14beb17c90ba58d5dc4975"
  end

  resource "inc::Module::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Module-Install-1.21.tar.gz"
    sha256 "fbf91007f30565f3920e106055fd0d4287981d5e7dad8b35323ce4b733f15a7b"
  end

  resource "Business::ISBN::Data" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Business-ISBN-Data-20250708.001.tar.gz"
    sha256 "a3a6d57e8855674640baec22d5f5e2fe068cc150da3986009d5803e44e126b31"
  end

  resource "Business::ISBN" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Business-ISBN-3.012.tar.gz"
    sha256 "567fecf073ed0ba2889bfe09c9f3c9996baf21bd2d48299b7330832809d501cb"
  end

  resource "Tie::Cycle" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Tie-Cycle-1.231.tar.gz"
    sha256 "84553d26db09b7eb3f15d809d82242214b5e4e268834a26574cefa83dd25c755"
  end

  resource "Business::ISMN" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Business-ISMN-1.205.tar.gz"
    sha256 "1c48e9b00bc32578b2176e6f79c4a11713d875befa8fbb7f48b7a9c8172fe8bd"
  end

  resource "Business::ISSN" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Business-ISSN-1.008.tar.gz"
    sha256 "b16b3a1b0e53cd45ed3328906d33ad4d59a13b57abf341424553aecf3e443aac"
  end

  resource "Class::Accessor" do
    url "https://cpan.metacpan.org/authors/id/K/KA/KASEI/Class-Accessor-0.51.tar.gz"
    sha256 "bf12a3e5de5a2c6e8a447b364f4f5a050bf74624c56e315022ae7992ff2f411c"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.50.tar.gz"
    sha256 "ca6e8d7ce7471c2be54e1009f64c367d7ee233a2894cacf52ebe6f53b04e81e5"
  end

  resource "Config::AutoConf" do
    url "https://cpan.metacpan.org/authors/id/A/AM/AMBS/Config-AutoConf-0.320.tar.gz"
    sha256 "bb57a958ef49d3f7162276dae14a7bd5af43fd1d8513231af35d665459454023"
  end

  resource "Text::Glob" do
    url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/Text-Glob-0.11.tar.gz"
    sha256 "069ccd49d3f0a2dedb115f4bdc9fbac07a83592840953d1fcdfc39eb9d305287"
  end

  resource "Number::Compare" do
    url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/Number-Compare-0.03.tar.gz"
    sha256 "83293737e803b43112830443fb5208ec5208a2e6ea512ed54ef8e4dd2b880827"
  end

  resource "File::Find::Rule" do
    url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/File-Find-Rule-0.35.tar.gz"
    sha256 "2bd556289a6d44ad2ee74803258bb0b0050d246f1e81caab0b263c303acf0c82"
  end

  resource "B::COW" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/B-COW-0.007.tar.gz"
    sha256 "1290daf227e8b09889a31cf182e29106f1cf9f1a4e9bf7752f9de92ed1158b44"
  end

  resource "Clone" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.47.tar.gz"
    sha256 "4c2c0cb9a483efbf970cb1a75b2ca75b0e18cb84bcb5c09624f86e26b09c211d"
  end

  resource "Data::Compare" do
    url "https://cpan.metacpan.org/authors/id/D/DC/DCANTRELL/Data-Compare-1.29.tar.gz"
    sha256 "53c9db3b93263c88aaa3c4072d819eaded024d7a36b38c0c37737d288d5afa8c"
  end

  resource "Data::Dump" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Data-Dump-1.25.tar.gz"
    sha256 "a4aa6e0ddbf39d5ad49bddfe0f89d9da864e3bc00f627125d1bc580472f53fbd"
  end

  resource "Data::Uniqid" do
    url "https://cpan.metacpan.org/authors/id/M/MW/MWX/Data-Uniqid-0.12.tar.gz"
    sha256 "b6919ba49b9fe98bfdf3e8accae7b9b7f78dc9e71ebbd0b7fef7a45d99324ccb"
  end

  resource "Class::Inspector" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Class-Inspector-1.36.tar.gz"
    sha256 "cc295d23a472687c24489d58226ead23b9fdc2588e522f0b5f0747741700694e"
  end

  resource "File::ShareDir" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-ShareDir-1.118.tar.gz"
    sha256 "3bb2a20ba35df958dc0a4f2306fc05d903d8b8c4de3c8beefce17739d281c958"
  end

  resource "File::ShareDir::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.14.tar.gz"
    sha256 "8f9533b198f2d4a9a5288cbc7d224f7679ad05a7a8573745599789428bc5aea0"
  end

  resource "Exporter::Tiny" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.006002.tar.gz"
    sha256 "6f295e2cbffb1dbc15bdb9dadc341671c1e0cd2bdf2d312b17526273c322638d"
  end

  resource "List::MoreUtils::XS" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz"
    sha256 "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242"
  end

  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.32.tar.gz"
    sha256 "ef2d6cab0bad18e3ab1c4e6125cc5f695c7e459899f512451c8fa3ef83fa7fc0"
  end

  resource "List::MoreUtils" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz"
    sha256 "63b1f7842cd42d9b538d1e34e0330de5ff1559e4c2737342506418276f646527"
  end

  resource "Module::Runtime" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Module-Runtime-0.018.tar.gz"
    sha256 "0bf77ef68e53721914ff554eada20973596310b4e2cf1401fc958601807de577"
  end

  resource "Module::Implementation" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Module-Implementation-0.09.tar.gz"
    sha256 "c15f1a12f0c2130c9efff3c2e1afe5887b08ccd033bd132186d1e7d5087fd66d"
  end

  resource "Params::Validate" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-Validate-1.31.tar.gz"
    sha256 "1bf2518ef2c4869f91590e219f545c8ef12ed53cf313e0eb5704adf7f1b2961e"
  end

  resource "Sub::Exporter::Progressive" do
    url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
    sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
  end

  resource "Variable::Magic" do
    url "https://cpan.metacpan.org/authors/id/V/VP/VPIT/Variable-Magic-0.64.tar.gz"
    sha256 "9f7853249c9ea3b4df92fb6b790c03a60680fc029f44c8bf9894dccf019516bd"
  end

  resource "B::Hooks::EndOfScope" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/B-Hooks-EndOfScope-0.28.tar.gz"
    sha256 "edac77a17fc36620c8324cc194ce1fad2f02e9fcbe72d08ad0b2c47f0c7fd8ef"
  end

  resource "Package::Stash::XS" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-XS-0.30.tar.gz"
    sha256 "26bad65c1959c57379b3e139dc776fbec5f702906617ef27cdc293ddf1239231"
  end

  resource "Package::Stash" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-0.40.tar.gz"
    sha256 "5a9722c6d9cb29ee133e5f7b08a5362762a0b5633ff5170642a5b0686e95e066"
  end

  resource "namespace::clean" do
    url "https://cpan.metacpan.org/authors/id/R/RI/RIBASUSHI/namespace-clean-0.27.tar.gz"
    sha256 "8a10a83c3e183dc78f9e7b7aa4d09b47c11fb4e7d3a33b9a12912fd22e31af9d"
  end

  resource "Sub::Identify" do
    url "https://cpan.metacpan.org/authors/id/R/RG/RGARCIA/Sub-Identify-0.14.tar.gz"
    sha256 "068d272086514dd1e842b6a40b1bedbafee63900e5b08890ef6700039defad6f"
  end

  resource "namespace::autoclean" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/namespace-autoclean-0.31.tar.gz"
    sha256 "d3b32c82e1d2caa9d58b8c8075965240e6cab66ab9350bd6f6bea4ca07e938d6"
  end

  resource "IPC::System::Simple" do
    url "https://cpan.metacpan.org/authors/id/J/JK/JKEENAN/IPC-System-Simple-1.30.tar.gz"
    sha256 "22e6f5222b505ee513058fdca35ab7a1eab80539b98e5ca4a923a70a8ae9ba9e"
  end

  resource "Eval::Closure" do
    url "https://cpan.metacpan.org/authors/id/D/DO/DOY/Eval-Closure-0.14.tar.gz"
    sha256 "ea0944f2f5ec98d895bef6d503e6e4a376fea6383a6bc64c7670d46ff2218cad"
  end

  resource "Class::Data::Inheritable" do
    url "https://cpan.metacpan.org/authors/id/R/RS/RSHERER/Class-Data-Inheritable-0.10.tar.gz"
    sha256 "aa1ae68a611357b7bfd9a2f64907cc196ddd6d047cae64ef9d0ad099d98ae54a"
  end

  resource "Devel::StackTrace" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.05.tar.gz"
    sha256 "63cb6196e986a7e578c4d28b3c780e7194835bfc78b68eeb8f00599d4444888c"
  end

  resource "Exception::Class" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Exception-Class-1.45.tar.gz"
    sha256 "5482a77ef027ca1f9f39e1f48c558356e954936fc8fbbdee6c811c512701b249"
  end

  resource "Role::Tiny" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.002004.tar.gz"
    sha256 "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45"
  end

  resource "MRO::Compat" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/MRO-Compat-0.15.tar.gz"
    sha256 "0d4535f88e43babd84ab604866215fc4d04398bd4db7b21852d4a31b1c15ef61"
  end

  resource "Sub::Quote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006008.tar.gz"
    sha256 "94bebd500af55762e83ea2f2bc594d87af828072370c7110c60c238a800d15b2"
  end

  resource "XString" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/XString-0.005.tar.gz"
    sha256 "f247f55c19aee6ba4a1ae73c0804259452e02ea85a9be07f8acf700a5138f884"
  end

  resource "Specio" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.51.tar.gz"
    sha256 "505f5de28bee55545b9ec0c45c1d5e4ae568d4f5dbb5e8eabe9d980cb9b68f93"
  end

  resource "Params::ValidationCompiler" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.31.tar.gz"
    sha256 "7b6497173f1b6adb29f5d51d8cf9ec36d2f1219412b4b2410e9d77a901e84a6d"
  end

  resource "Path::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.148.tar.gz"
    sha256 "818aed754b74f399e42c238bea738e20a52af89a6e3feb58bec9d0130eea4746"
  end

  resource "DateTime::Locale" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.45.tar.gz"
    sha256 "1bc56dc2ff4b3152612e1d474ca65071ae2c00912e3fa4bc6f5a99e5e7a1da68"
  end

  resource "Class::Singleton" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHAY/Class-Singleton-1.6.tar.gz"
    sha256 "27ba13f0d9512929166bbd8c9ef95d90d630fc80f0c9a1b7458891055e9282a4"
  end

  resource "List::SomeUtils::XS" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/List-SomeUtils-XS-0.58.tar.gz"
    sha256 "4f9e4d2622481b79cc298e8e29de8a30943aff9f4be7992c0ebb7b22e5b4b297"
  end

  resource "List::SomeUtils" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/List-SomeUtils-0.59.tar.gz"
    sha256 "fab30372e4c67bf5a46062da38d1d0c8756279feada866eb439fa29571a2dc7b"
  end

  resource "List::UtilsBy" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/List-UtilsBy-0.12.tar.gz"
    sha256 "fff1281fd469fe982b1a58044becfd970f313bff3a26e1c7b2b3f4c0a5ed71e0"
  end

  resource "Scalar::Util" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.69.tar.gz"
    sha256 "49108037dc31ba4953aa8be57c1c72f3e922dde1fa328f1eb39a329f1e6314fc"
  end

  resource "List::AllUtils" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/List-AllUtils-0.19.tar.gz"
    sha256 "30a8146ab21a7787b8c56d5829cf9a7f2b15276d3b3fca07336ac38d3002ffbc"
  end

  resource "DateTime::TimeZone" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.65.tar.gz"
    sha256 "019e99ca8e8c655d70d6813b6df3f351c2bee5983e0f4732f18c5788e1d38e62"
  end

  resource "DateTime" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-1.66.tar.gz"
    sha256 "afabd686fb83d3ebf49ee453974f9122f3eec9b25ff8d2ddf4f12de92af1e5e2"
  end

  resource "DateTime::Calendar::Julian" do
    url "https://cpan.metacpan.org/authors/id/W/WY/WYANT/DateTime-Calendar-Julian-0.107.tar.gz"
    sha256 "fcb2b424844bb13bcad46b1c7aa239b5a09bab2556f53bd1f27fad90c260d33d"
  end

  resource "DateTime::Format::Strptime" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Format-Strptime-1.79.tar.gz"
    sha256 "701e46802c86ed4d88695c1a6dacbbe90b3390beeb794f387e7c792300037579"
  end

  resource "DateTime::Format::Builder" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Format-Builder-0.83.tar.gz"
    sha256 "61ffb23d85b3ca1786b2da3289e99b57e0625fe0e49db02a6dc0cb62c689e2f2"
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

  resource "IO::String" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz"
    sha256 "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0"
  end

  resource "IPC::Run3" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/IPC-Run3-0.049.tar.gz"
    sha256 "9d048ae7b9ae63871bae976ba01e081d887392d904e5d48b04e22d35ed22011a"
  end

  resource "Lingua::Translit" do
    url "https://cpan.metacpan.org/authors/id/A/AL/ALINKE/Lingua-Translit-0.29.tar.gz"
    sha256 "1ad2fabc0079dad708b7d9d55437c9ebb192e610bf960af25945858b92597752"
  end

  resource "Log::Log4perl" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/Log-Log4perl-1.57.tar.gz"
    sha256 "0f8fcb7638a8f3db4c797df94fdbc56013749142f2f94cbc95b43c9fca096a13"
  end

  resource "Mozilla::CA" do
    url "https://cpan.metacpan.org/authors/id/L/LW/LWP/Mozilla-CA-20250602.tar.gz"
    sha256 "adeac0752440b2da094e8036bab6c857e22172457658868f5ac364f0c7b35481"
  end

  resource "Net::SSLeay" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.94.tar.gz"
    sha256 "9d7be8a56d1bedda05c425306cc504ba134307e0c09bda4a788c98744ebcd95d"
  end

  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.32.tar.gz"
    sha256 "9632067d34e14e0dae2da94631c4f25a387fcc48d06fa29330e8b3c04c4e913d"
  end

  resource "IO::Socket::SSL" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.094.tar.gz"
    sha256 "b2446889cb5e20545d782c4676da1b235673a81c181689aaae2492589d84bf02"
  end

  resource "Encode::Locale" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
    sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
  end

  # looks like 2.33 got recalled, but still downloadable
  # latest release on cpan is 0.05
  resource "Time::Date" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
    sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
  end

  resource "HTTP::Date" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
    sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
  end

  resource "File::Listing" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.16.tar.gz"
    sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
  end

  resource "HTML::Tagset" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz"
    sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
  end

  resource "IO::HTML" do
    url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
    sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
  end

  resource "LWP::MediaTypes" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
    sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
  end

  resource "HTTP::Message" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-7.00.tar.gz"
    sha256 "5afa95eb6ed1c632e81656201a2738e2c1bc6cbfae2f6d82728e2bb0b519c1dc"
  end

  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.83.tar.gz"
    sha256 "7278ce9791256132b26a71a5719451844704bb9674b58302c3486df43584f8c0"
  end

  resource "HTTP::Cookies" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.11.tar.gz"
    sha256 "8c9a541a4a39f6c0c7e3d0b700b05dfdb830bd490a1b1942a7dedd1b50d9a8c8"
  end

  resource "HTTP::Daemon" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Daemon-6.16.tar.gz"
    sha256 "b38d092725e6fa4e0c4dc2a47e157070491bafa0dbe16c78a358e806aa7e173d"
  end

  resource "HTTP::Negotiate" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end

  resource "Net::HTTP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.23.tar.gz"
    sha256 "0d65c09dd6c8589b2ae1118174d3c1a61703b6ecfc14a3442a8c74af65e0c94e"
  end

  resource "WWW::RobotRules" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end

  resource "LWP::Protocol::http" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.79.tar.gz"
    sha256 "f2526e9a33ac96715cc47fbf5b4bec1a8c51720330b24e3974c2c5ae07a9c5e7"
  end

  resource "LWP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.79.tar.gz"
    sha256 "f2526e9a33ac96715cc47fbf5b4bec1a8c51720330b24e3974c2c5ae07a9c5e7"
  end

  resource "LWP::Protocol::https" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.14.tar.gz"
    sha256 "59cdeabf26950d4f1bef70f096b0d77c5b1c5a7b5ad1b66d71b681ba279cbb2a"
  end

  resource "Parse::RecDescent" do
    url "https://cpan.metacpan.org/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967015.tar.gz"
    sha256 "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37"
  end

  resource "PerlIO::utf8_strict" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/PerlIO-utf8_strict-0.010.tar.gz"
    sha256 "bcd2848b72df290b5e984fae8b1a6ca96f6d072003cf222389a8c9e8e1c570cd"
  end

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2024080801.tar.gz"
    sha256 "0677afaec8e1300cefe246b4d809e75cdf55e2cc0f77c486d13073b69ab4fbdd"
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
    url "https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/Text-CSV_XS-1.60.tgz"
    sha256 "798f8b45d5d4a24e34faeec6ae157d62356556ea0ba046d8e80f8fbf5c826911"
  end

  resource "Text::Roman" do
    url "https://cpan.metacpan.org/authors/id/S/SY/SYP/Text-Roman-3.5.tar.gz"
    sha256 "cb4a08a3b151802ffb2fce3258a416542ab81db0f739ee474a9583ffb73e046a"
  end

  resource "Unicode::GCString" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end

  resource "MIME::Charset" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/MIME-Charset-1.013.1.tar.gz"
    sha256 "1bb7a6e0c0d251f23d6e60bf84c9adefc5b74eec58475bfee4d39107e60870f0"
  end

  resource "Unicode::LineBreak" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end

  resource "FFI::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/FFI-CheckLib-0.31.tar.gz"
    sha256 "04d885fc377d44896e5ea1c4ec310f979bb04f2f18658a7e7a4d509f7e80bb80"
  end

  resource "File::chdir" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1011.tar.gz"
    sha256 "31ebf912df48d5d681def74b9880d78b1f3aca4351a0ed1fe3570b8e03af6c79"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end

  resource "Alien::Build::Plugin::Download::GitLab" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-Plugin-Download-GitLab-0.01.tar.gz"
    sha256 "c1f089c8ea152a789909d48a83dbfcf2626f773daf30431c8622582b26aba902"
  end

  resource "Alien::Build" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.84.tar.gz"
    sha256 "8e891fd3acbac39dd8fdc01376b9abff931e625be41e0910ca30ad59363b4477"
  end

  resource "Alien::Libxml2" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.20.tar.gz"
    sha256 "56aae7b339bbeb02f77c5801f57a821be5791b51f43bf7f9062bb3bfa444c328"
  end

  resource "XML::NamespaceSupport" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz"
    sha256 "47e995859f8dd0413aa3f22d350c4a62da652e854267aa0586ae544ae2bae5ef"
  end

  resource "XML::SAX::Base" do
    url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz"
    sha256 "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0"
  end

  resource "XML::SAX" do
    url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-1.02.tar.gz"
    sha256 "4506c387043aa6a77b455f00f57409f3720aa7e553495ab2535263b4ed1ea12a"
  end

  resource "XML::LibXML" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0210.tar.gz"
    sha256 "a29bf3f00ab9c9ee04218154e0afc8f799bf23674eb99c1a9ed4de1f4059a48d"
  end

  resource "XML::LibXML::Simple" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/XML-LibXML-Simple-1.01.tar.gz"
    sha256 "cd98c8104b70d7672bfa26b4513b78adf2b4b9220e586aa8beb1a508500365a6"
  end

  resource "XML::LibXSLT" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXSLT-2.003000.tar.gz"
    sha256 "7caa5aee72f53be59d8b84eecb6864a07c612a12ea6b27d5c706960edcd54587"
  end

  resource "XML::Writer" do
    url "https://cpan.metacpan.org/authors/id/J/JO/JOSEPHW/XML-Writer-0.900.tar.gz"
    sha256 "73c8f5bd3ecf2b350f4adae6d6676d52e08ecc2d7df4a9f089fa68360d400d1f"
  end

  resource "autovivification" do
    url "https://cpan.metacpan.org/authors/id/V/VP/VPIT/autovivification-0.18.tar.gz"
    sha256 "2d99975685242980d0a9904f639144c059d6ece15899efde4acb742d3253f105"
  end

  resource "Clone::Choose" do
    url "https://cpan.metacpan.org/authors/id/H/HE/HERMES/Clone-Choose-0.010.tar.gz"
    sha256 "5623481f58cee8edb96cd202aad0df5622d427e5f748b253851dfd62e5123632"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"
    ENV["PERL_MM_USE_DEFAULT"] = "1"
    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix

    resources.each do |r|
      r.stage do
        # fix libbtparse.so linkage failure on Linux
        if r.name == "Text::BibTeX" && OS.linux?
          inreplace "inc/MyBuilder.pm",
                    "-lbtparse",
                    "-Wl,-rpath,#{libexec}/lib -lbtparse"
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

    bin_before = Dir[libexec/"bin/*"].to_set
    system "perl", "Build.PL", "--install_base", libexec
    system "./Build"
    system "./Build", "install"
    bin_after = Dir[libexec/"bin/*"].to_set
    (bin_after - bin_before).each do |file|
      basename = Pathname(file).basename
      (bin/basename).write_env_script file, PERL5LIB: ENV["PERL5LIB"]
    end
    man1.install libexec/"man/man1/biber.1"
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
