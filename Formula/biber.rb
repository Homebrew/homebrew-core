class Biber < Formula
  desc "Backend processor for BibLaTeX"
  homepage "https://sourceforge.net/projects/biblatex-biber/"
  url "https://github.com/plk/biber/archive/refs/tags/v2.19.tar.gz"
  sha256 "1c1266bc8adb1637c4c59e23c47d919c5a38da4e53544a3c22c21de4a68fc9fe"
  license "Artistic-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f522597c2ed6494559a9b0cdb00fee94ce70fd7e215493f3a930b1faa4477ee"
    sha256 cellar: :any,                 arm64_monterey: "cc12ff76b53af1c1456260dad3b2f9ba0caa2e4d71461c5989a1d9ba417d6b71"
    sha256 cellar: :any,                 arm64_big_sur:  "ee379665659d8b460d402fcd3747af3fa15bcdaaa446ece0a76038982a6da7fe"
    sha256 cellar: :any,                 ventura:        "ead523a858abe50f746a6e83efefdb3ef73385c66cba06ffe00dcdbf61ef9c5e"
    sha256 cellar: :any,                 monterey:       "93e69afca08cbe73976d44661eebf6889bda77a240ad2fa7e6f855d09fd1756c"
    sha256 cellar: :any,                 big_sur:        "6634422133ae03bfa6353c230259af926f571eb6b3f64881b4f122153c4e981f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4484229ee69a48419cae84503dfd13453ebf66914cc300c297c9e2a09ec4568f"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "perl"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4232.tar.gz"
    sha256 "67c82ee245d94ba06decfa25572ab75fdcd26a9009094289d8f45bc54041771b"
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
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz"
    sha256 "7d580ff6ace0cbe555bf36b86dc8ea232581530cbeaaea09bccb57b55797f11c"
  end
  resource "YAML::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.73.tar.gz"
    sha256 "bc315fa12e8f1e3ee5e2f430d90b708a5dc7e47c867dba8dce3a6b8fbe257744"
  end
  resource "Module::ScanDeps" do
    url "https://cpan.metacpan.org/authors/id/R/RS/RSCHUPP/Module-ScanDeps-1.31.tar.gz"
    sha256 "fc4d98d2b0015745f3b55b51ddf4445a73b069ad0cb7ec36d8ea781d61074d9d"
  end
  resource "File::Remove" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/File-Remove-1.61.tar.gz"
    sha256 "fd857f585908fc503461b9e48b3c8594e6535766bc14beb17c90ba58d5dc4975"
  end
  resource "inc::Module::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Module-Install-1.19.tar.gz"
    sha256 "1a53a78ddf3ab9e3c03fc5e354b436319a944cba4281baf0b904fa932a13011b"
  end
  resource "Business::ISBN::Data" do
    url "https://cpan.metacpan.org/authors/id/B/BD/BDFOY/Business-ISBN-Data-20210112.006.tar.gz"
    sha256 "98c2cfb266b5fdd016989abaa471d9dd4c1d593c508a6f01f66d184d5fee8bae"
  end
  resource "Business::ISBN" do
    url "https://cpan.metacpan.org/authors/id/B/BD/BDFOY/Business-ISBN-3.007.tar.gz"
    sha256 "50cc4686dd21c9537b49a231d71711e814ebd2f19aa4ca331baf92ff2de5ce19"
  end
  resource "Tie::Cycle" do
    url "https://cpan.metacpan.org/authors/id/B/BD/BDFOY/Tie-Cycle-1.227.tar.gz"
    sha256 "7838335791e71a3b33b8a19de3052949e1890a4823def6397823c99222fa1dd8"
  end
  resource "Business::ISMN" do
    url "https://cpan.metacpan.org/authors/id/B/BD/BDFOY/Business-ISMN-1.202.tar.gz"
    sha256 "ca8db9253ddda906b47d5068e745b9f2a03754589455ffcf26b0706c8194db26"
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
    url "https://cpan.metacpan.org/authors/id/D/DC/DCANTRELL/Data-Compare-1.27.tar.gz"
    sha256 "818a20f1f38f74e65253cf8bcf6fed7f94a5a8dd662f75330dcaf4b117cee8bd"
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
    url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.006000.tar.gz"
    sha256 "d95479ff085699d6422f7fc8306db085e34b626438deb82ec82d41df2295f400"
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
    url "https://cpan.metacpan.org/authors/id/V/VP/VPIT/Variable-Magic-0.63.tar.gz"
    sha256 "ba4083b2c31ff2694f2371333d554c826aaf24b4d98d03e48b5b4a43a2a0e679"
  end
  resource "B::Hooks::EndOfScope" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/B-Hooks-EndOfScope-0.26.tar.gz"
    sha256 "39df2f8c007a754672075f95b90797baebe97ada6d944b197a6352709cb30671"
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
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.04.tar.gz"
    sha256 "cd3c03ed547d3d42c61fa5814c98296139392e7971c092e09a431f2c9f5d6855"
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
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.37.tar.gz"
    sha256 "f70cc4e450f441767ac1a0b8655b6f1de46c43e8d1c9d05f2e0924a16be0cb6b"
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
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.57.tar.gz"
    sha256 "39847cc95b7a3e65003286d47445dbc88c3702239dce2f4b624cf744bdd642f3"
  end
  resource "DateTime" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-1.59.tar.gz"
    sha256 "de3e9a63ce15470b4db4adad4ba6ac8ec297d88c0c6c6b354b081883b0a67695"
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
    url "https://cpan.metacpan.org/authors/id/D/DA/DANKOGAI/Encode-JIS2K-0.03.tar.gz"
    sha256 "1ec84d72db39deb4dad6fca95acfcc21033f45a24d347c20f9a1a696896c35cc"
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
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/IPC-Run3-0.048.tar.gz"
    sha256 "3d81c3cc1b5cff69cca9361e2c6e38df0352251ae7b41e2ff3febc850e463565"
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
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Mozilla-CA-20221114.tar.gz"
    sha256 "701bea67be670add5a102f9f8c879402b4983096b1cb0e20dd47d52d7a10666b"
  end
  resource "Net::SSLeay" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.92.tar.gz"
    sha256 "47c2f2b300f2e7162d71d699f633dd6a35b0625a00cbda8c50ac01144a9396a9"
  end
  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.17.tar.gz"
    sha256 "5f7e42b769cb27499113cfae4b786c37d49e7c7d32dbb469602cd808308568f8"
  end
  resource "IO::Socket::SSL" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.081.tar.gz"
    sha256 "07bdf826a8d6b463316d241451c890d1012fa2499a83d8e3d00ce0a584618443"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
    sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
  end
  resource "File::Listing" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.15.tar.gz"
    sha256 "46c4fb9f9eb9635805e26b7ea55b54455e47302758a10ed2a0b92f392713770c"
  end
  resource "HTML::Tagset" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz"
    sha256 "adb17dac9e36cd011f5243881c9739417fd102fce760f8de4e9be4c7131108e2"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.44.tar.gz"
    sha256 "398b647bf45aa972f432ec0111f6617742ba32fc773c6612d21f64ab4eacbca1"
  end
  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.81.tar.gz"
    sha256 "c0910a5c8f92f8817edd06ccfd224ba1c2ebe8c10f551f032587a1fc83d62ff2"
  end
  resource "HTTP::Cookies" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.10.tar.gz"
    sha256 "e36f36633c5ce6b5e4b876ffcf74787cc5efe0736dd7f487bdd73c14f0bd7007"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.22.tar.gz"
    sha256 "62faf9a5b84235443fe18f780e69cecf057dea3de271d7d8a0ba72724458a1a2"
  end
  resource "WWW::RobotRules" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end
  resource "LWP::Protocol::http" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.68.tar.gz"
    sha256 "42784a5869855ee08522dfb1d30fccf98ca4ddefa8c6c1bcb0d68a0adceb7f01"
  end
  resource "LWP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.68.tar.gz"
    sha256 "42784a5869855ee08522dfb1d30fccf98ca4ddefa8c6c1bcb0d68a0adceb7f01"
  end
  resource "LWP::Protocol::https" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.10.tar.gz"
    sha256 "cecfc31fe2d4fc854cac47fce13d3a502e8fdfe60c5bc1c09535743185f2a86c"
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
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/Text-CSV-2.02.tar.gz"
    sha256 "84120de3e10489ea8fbbb96411a340c32cafbe5cdff7dd9576b207081baa9d24"
  end
  resource "Text::CSV_XS" do
    url "https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/Text-CSV_XS-1.50.tgz"
    sha256 "85b5e1bed7e11dc0413d4e920cee25d980de47376c0048029041cf461eac96b1"
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
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.77.tar.gz"
    sha256 "fbf39ef634e364616e43e851c15a195ffa157b5cd7c9d89abfd8e31b6b11f1e9"
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
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0208.tar.gz"
    sha256 "0c006b03bf8d0eb531fb56bda3ae15754ca56d888dd7b9e805ab9eb19d5fd653"
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
    ENV["OPENSSL_PREFIX"] = Formula["openssl@1.1"].opt_prefix

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
  end
end
