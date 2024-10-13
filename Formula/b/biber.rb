class Biber < Formula
  desc "Backend processor for BibLaTeX"
  homepage "https://sourceforge.net/projects/biblatex-biber/"
  url "https://github.com/plk/biber/archive/refs/tags/v2.20.tar.gz"
  sha256 "19f0312e59bf2f5711b8d69b3585a0ca894c36574f086fbb8d53ccd5c0a45ff9"
  license "Artistic-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "c3ea4ec23f241784f3141c50ded0bad178b9a3ed8bb1189f3279df9a56756c97"
    sha256 cellar: :any,                 arm64_sonoma:   "f018ab37e28a17160227cd2628a212c1118e19295d0d9eb90b42ad7f0b7761bb"
    sha256 cellar: :any,                 arm64_ventura:  "36185def50483b55f1eca670196469b4fef358ea861260bc1f40062d1535204f"
    sha256 cellar: :any,                 arm64_monterey: "0bd8bb16155244410aaca2fe01bf11f560e6a97aa0941a3f190d26f8d911662e"
    sha256 cellar: :any,                 sonoma:         "ecc3b942b3546d18d023cc50234c5bf2f0a14ff729cc646bd7725eaa0787b3f9"
    sha256 cellar: :any,                 ventura:        "49f979490d7e6f2305ec6f94a364521d7d119e5e152c74d17c90c50b39e16a86"
    sha256 cellar: :any,                 monterey:       "0413d6cce8ba9e7e936824f1e8fe7850b686bdf07614a73ecf1e446d949b922c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6f325f4d18b733f2e11753a7283b9f58bd3ff95852ccaf71f3d052bb679b33"
  end

  depends_on "pkg-config" => :build
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
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Config-0.008.tar.gz"
    sha256 "ae5104f634650dce8a79b7ed13fb59d67a39c213a6776cfdaa3ee749e62f1a8c"
  end

  resource "ExtUtils::Helpers" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.026.tar.gz"
    sha256 "de901b6790a4557cf4ec908149e035783b125bf115eb9640feb1bc1c24c33416"
  end

  resource "ExtUtils::InstallPaths" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.012.tar.gz"
    sha256 "84735e3037bab1fdffa3c2508567ad412a785c91599db3c12593a50a1dd434ed"
  end

  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.047.tar.gz"
    sha256 "71260e9421b93c33dd1b3e7d0cf15f759c0ca7c753fa840279ec3be70f8f8c9d"
  end

  resource "YAML::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.74.tar.gz"
    sha256 "7b38ca9f5d3ce24230a6b8bdc1f47f5b2db348e7f7f9666c26f5955636e33d6c"
  end

  resource "Module::ScanDeps" do
    url "https://cpan.metacpan.org/authors/id/R/RS/RSCHUPP/Module-ScanDeps-1.35.tar.gz"
    sha256 "e5beb3adf55be3dab71f9a1416d4bad57b14e5e05c96370741b9d8f96a51b612"
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
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Business-ISBN-Data-20240321.001.tar.gz"
    sha256 "8a307ce5e161a6197501f1d96704da01107ef8ed5b7b290d96152a9ba3e1cfdd"
  end

  resource "Business::ISBN" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Business-ISBN-3.009.tar.gz"
    sha256 "d2ec1970454af1b2c099dd34caa7a348ca6fd323bb7ddbfad55389bd7f96789b"
  end

  resource "Tie::Cycle" do
    url "https://cpan.metacpan.org/authors/id/B/BD/BDFOY/Tie-Cycle-1.228.tar.gz"
    sha256 "875651be1c657d85bcac056a76be22888395412c8e5af3d84d4c37b8fbb5b448"
  end

  resource "Business::ISMN" do
    url "https://cpan.metacpan.org/authors/id/B/BR/BRIANDFOY/Business-ISMN-1.204.tar.gz"
    sha256 "14e14599bd6e231b722297f84d4e8a5c695c79ada79ea0b50693d5f04ded3689"
  end

  resource "Business::ISSN" do
    url "https://cpan.metacpan.org/authors/id/B/BD/BDFOY/Business-ISSN-1.005.tar.gz"
    sha256 "3b09b0267f0a6660fb92b6f50c4c7796ef6a263b62ad3bbeaa07189a0c7c39b3"
  end

  resource "Class::Accessor" do
    url "https://cpan.metacpan.org/authors/id/K/KA/KASEI/Class-Accessor-0.51.tar.gz"
    sha256 "bf12a3e5de5a2c6e8a447b364f4f5a050bf74624c56e315022ae7992ff2f411c"
  end

  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz"
    sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
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
    url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/File-Find-Rule-0.34.tar.gz"
    sha256 "7e6f16cc33eb1f29ff25bee51d513f4b8a84947bbfa18edb2d3cc40a2d64cafe"
  end

  resource "B::COW" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/B-COW-0.007.tar.gz"
    sha256 "1290daf227e8b09889a31cf182e29106f1cf9f1a4e9bf7752f9de92ed1158b44"
  end

  resource "Clone" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Clone-0.46.tar.gz"
    sha256 "aadeed5e4c8bd6bbdf68c0dd0066cb513e16ab9e5b4382dc4a0aafd55890697b"
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
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
    sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
  end

  resource "List::MoreUtils" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz"
    sha256 "63b1f7842cd42d9b538d1e34e0330de5ff1559e4c2737342506418276f646527"
  end

  resource "Module::Runtime" do
    url "https://cpan.metacpan.org/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz"
    sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
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
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/namespace-autoclean-0.29.tar.gz"
    sha256 "45ebd8e64a54a86f88d8e01ae55212967c8aa8fed57e814085def7608ac65804"
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
    url "https://cpan.metacpan.org/authors/id/R/RS/RSHERER/Class-Data-Inheritable-0.09.tar.gz"
    sha256 "44088d6e90712e187b8a5b050ca5b1c70efe2baa32ae123e9bd8f59f29f06e4d"
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
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.48.tar.gz"
    sha256 "0c85793580f1274ef08173079131d101f77b22accea7afa8255202f0811682b2"
  end

  resource "Params::ValidationCompiler" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.31.tar.gz"
    sha256 "7b6497173f1b6adb29f5d51d8cf9ec36d2f1219412b4b2410e9d77a901e84a6d"
  end

  resource "Path::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.144.tar.gz"
    sha256 "f6ea094ece845c952a02c2789332579354de8d410a707f9b7045bd241206487d"
  end

  resource "DateTime::Locale" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.40.tar.gz"
    sha256 "7490b4194b5d23a4e144976dedb3bdbcc6d3364b5d139cc922a86d41fdb87afb"
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
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.63.tar.gz"
    sha256 "cafbdf212f6827dc9a0dd3b57b6ee50e860586d7198228a33262d55c559eb2a9"
  end

  resource "List::AllUtils" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/List-AllUtils-0.19.tar.gz"
    sha256 "30a8146ab21a7787b8c56d5829cf9a7f2b15276d3b3fca07336ac38d3002ffbc"
  end

  resource "DateTime::TimeZone" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.62.tar.gz"
    sha256 "6214f9c9c8dfa2000bae912ef2b8ebc5b163a83a0b5b2a82705162dad63466fa"
  end

  resource "DateTime" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-1.65.tar.gz"
    sha256 "0bfda7ff0253fb3d88cf4bdb5a14afb8cea24d147975d5bdf3c88b40e7ab140e"
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
    url "https://cpan.metacpan.org/authors/id/A/AM/AMBS/ExtUtils-LibBuilder-0.08.tar.gz"
    sha256 "c51171e06de53039f0bca1d97a6471ec37941ff59e8a3d1cb170ebdd2573b5d2"
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
    url "https://cpan.metacpan.org/authors/id/L/LW/LWP/Mozilla-CA-20240313.tar.gz"
    sha256 "624873939e309833894f881464a95dfe74ab77cab5d557308c010487161698e7"
  end

  resource "Net::SSLeay" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.94.tar.gz"
    sha256 "9d7be8a56d1bedda05c425306cc504ba134307e0c09bda4a788c98744ebcd95d"
  end

  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.27.tar.gz"
    sha256 "11962d8a8a8496906e5d34774affc235a1c95c112d390c0b4171f3e91e9e2a97"
  end

  resource "IO::Socket::SSL" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.085.tar.gz"
    sha256 "95b2f7c0628a7e246a159665fbf0620d0d7835e3a940f22d3fdd47c3aa799c2e"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.45.tar.gz"
    sha256 "01cb8406612a3f738842d1e97313ae4d874870d1b8d6d66331f16000943d4cbe"
  end

  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.82.tar.gz"
    sha256 "5b1f20dd0e471a049c13a53d0fcd0442f58518889180536c6f337112c9a430d8"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.77.tar.gz"
    sha256 "94a907d6b3ea8d966ef43deffd4fa31f5500142b4c00489bfd403860a5f060e4"
  end

  resource "LWP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.77.tar.gz"
    sha256 "94a907d6b3ea8d966ef43deffd4fa31f5500142b4c00489bfd403860a5f060e4"
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
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz"
    sha256 "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b"
  end

  resource "Sort::Key" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SALVA/Sort-Key-1.33.tar.gz"
    sha256 "ed6a4ccfab094c9cd164f564024e98bd21d94f4312ccac4d6246d22b34081acf"
  end

  resource "Text::BibTeX" do
    url "https://cpan.metacpan.org/authors/id/A/AM/AMBS/Text-BibTeX-0.89.tar.gz"
    sha256 "88a78ebf088ec7502f401c5a2b138c862cf5458534b773223bbf3aaf41224196"
  end

  resource "Text::CSV" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/Text-CSV-2.04.tar.gz"
    sha256 "4f80122e4ea0b05079cad493e386564030f18c8d7b1f9af561df86985a653fe3"
  end

  resource "Text::CSV_XS" do
    url "https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/Text-CSV_XS-1.53.tgz"
    sha256 "ba3231610fc755a69e14eb4a3c6d8cce46cc4fd32853777a6c9ce485a8878b42"
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
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.80.tar.gz"
    sha256 "d9edc936b06705bb5cb5ee5a2ea8bcf6111a3e8815914f177e15e3c0fed301f3"
  end

  resource "Alien::Libxml2" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.19.tar.gz"
    sha256 "f4a674099bbd5747c0c3b75ead841f3b244935d9ef42ba35368024bd611174c9"
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
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXSLT-2.002001.tar.gz"
    sha256 "df8927c4ff1949f62580d1c1e6f00f0cd56b53d3a957ee4b171b59bffa63b2c0"
  end

  resource "XML::Writer" do
    url "https://cpan.metacpan.org/authors/id/J/JO/JOSEPHW/XML-Writer-0.900.tar.gz"
    sha256 "73c8f5bd3ecf2b350f4adae6d6676d52e08ecc2d7df4a9f089fa68360d400d1f"
  end

  resource "autovivification" do
    url "https://cpan.metacpan.org/authors/id/V/VP/VPIT/autovivification-0.18.tar.gz"
    sha256 "2d99975685242980d0a9904f639144c059d6ece15899efde4acb742d3253f105"
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
    assert_predicate testpath/"annotations.bcf.html", :exist?
    assert_predicate testpath/"annotations.blg", :exist?
    assert_predicate testpath/"annotations.bbl", :exist?

    (testpath/"test.bib").write <<~EOS
      @book{test,
        author = {Test},
        title = {Test}
      }
    EOS
    (testpath/"test.latex").write <<~EOS
      \\documentclass{article}
      \\usepackage[backend=biber]{biblatex}
      \\bibliography{test}
      \\begin{document}
      \\cite{test}
      \\printbibliography
      \\end{document}
    EOS
    system Formula["texlive"].bin/"pdflatex", "-interaction=errorstopmode", testpath/"test.latex"
    system bin/"biber", "test"
    assert_predicate testpath/"test.bbl", :exist?
  end
end
