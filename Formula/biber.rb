class Biber < Formula
  desc "Backend processor for BibLaTeX"
  homepage "https://sourceforge.net/projects/biblatex-biber/"
  url "https://github.com/plk/biber/archive/refs/tags/v2.17.tar.gz"
  sha256 "1ee7efdd8343e982046f2301c1b0dcf09e1f9a997ac86ed1018dcb41d04c9e88"
  license "Artistic-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2c83db51b9605d5f1db3d1dc8b7b96a265df34f221adfe892877b142b11ad55"
    sha256 cellar: :any,                 arm64_monterey: "a879a966a62c17a8a2b136dada68b2a30350f42ff66c470dd6ee76ffcab12fe8"
    sha256 cellar: :any,                 arm64_big_sur:  "12452426c592e0bdff304dc61c7c1329557e875be3d71a145563773128c2733b"
    sha256 cellar: :any,                 ventura:        "a896b309dbc1914ac3377e26a23c8b36787f06caf181db4a7c8d3e77271c6464"
    sha256 cellar: :any,                 monterey:       "1e3a38acf7a0a4e4cf19539b0ddb461cf3e8d45e37cd8b0344d7f402c95344f4"
    sha256 cellar: :any,                 big_sur:        "e8882142cef7e0e9fb4f0d7a5b5e056f13fef904c6f0d5e78017c2e7774b39d5"
    sha256 cellar: :any,                 catalina:       "4890288756a20842b0aeb8c9c4375fa7e672e3ab43a81dd5ed9a83ddf1929f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35a84101695871ef736814e0a60e0cb6c62439f27a5f8cbf91168e30f021e5f9"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "perl"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz"
    sha256 "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717"
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
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/File-Remove-1.60.tar.gz"
    sha256 "e86e2a40ffedc6d5697d071503fd6ba14a5f9b8220af3af022110d8e724f8ca6"
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
    url "https://cpan.metacpan.org/authors/id/B/BD/BDFOY/Business-ISBN-3.006.tar.gz"
    sha256 "c1fefe68354ffb80cdbd24303ebe684b3b6828df3d5f09b429a09fc4f0919c9a"
  end
  resource "Tie::Cycle" do
    url "https://cpan.metacpan.org/authors/id/B/BD/BDFOY/Tie-Cycle-1.226.tar.gz"
    sha256 "0987e1c053bb080c3052710e9733a81ab6fb84e60da76828efa7fc92e7f47633"
  end
  resource "Business::ISMN" do
    url "https://cpan.metacpan.org/authors/id/B/BD/BDFOY/Business-ISMN-1.202.tar.gz"
    sha256 "ca8db9253ddda906b47d5068e745b9f2a03754589455ffcf26b0706c8194db26"
  end
  resource "Business::ISSN" do
    url "https://cpan.metacpan.org/authors/id/B/BD/BDFOY/Business-ISSN-1.004.tar.gz"
    sha256 "97ecab15d24d11e2852bf0b28f84c8798bd38402a0a69e17be0e6689b272715e"
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
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/B-COW-0.004.tar.gz"
    sha256 "fcafb775ed84a45bc2c06c5ffd71342cb3c06fb0bdcd5c1b51b0c12f8b585f51"
  end
  resource "Clone" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.45.tar.gz"
    sha256 "cbb6ee348afa95432e4878893b46752549e70dc68fe6d9e430d1d2e99079a9e6"
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
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.13.tar.gz"
    sha256 "45befdf0d95cbefe7c25a1daf293d85f780d6d2576146546e6828aad26e580f9"
  end
  resource "Exporter::Tiny" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.002002.tar.gz"
    sha256 "00f0b95716b18157132c6c118ded8ba31392563d19e490433e9a65382e707101"
  end
  resource "List::MoreUtils::XS" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz"
    sha256 "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242"
  end
  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.30.tar.gz"
    sha256 "da5bd0d5c903519bbf10bb9ba0cb7bcac0563882bcfe4503aee3fb143eddef6b"
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
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-Validate-1.30.tar.gz"
    sha256 "9a3a35583d3125d07e8c802c1f92f5be7d526e76dd496e944da270b1e273d812"
  end
  resource "Sub::Exporter::Progressive" do
    url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
    sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
  end
  resource "Variable::Magic" do
    url "https://cpan.metacpan.org/authors/id/V/VP/VPIT/Variable-Magic-0.62.tar.gz"
    sha256 "3f9a18517e33f006a9c2fc4f43f01b54abfe6ff2eae7322424f31069296b615c"
  end
  resource "B::Hooks::EndOfScope" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/B-Hooks-EndOfScope-0.25.tar.gz"
    sha256 "da1b6a9f7c7424776363182f9673e666b06136f13dc744241f7adce3d1ad0c1a"
  end
  resource "Package::Stash::XS" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-XS-0.29.tar.gz"
    sha256 "d3676ba94641e03d6a30e951f09266c4c3ca3f5b58aa7b314a67f28e419878aa"
  end
  resource "Package::Stash" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-0.39.tar.gz"
    sha256 "9165f555112e080493ce0e9129de0886da30b2593fb353a2abd1c76b2d2621b5"
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
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/MRO-Compat-0.13.tar.gz"
    sha256 "8a2c3b6ccc19328d5579d02a7d91285e2afd85d801f49d423a8eb16f323da4f8"
  end
  resource "Sub::Quote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006006.tar.gz"
    sha256 "6e4e2af42388fa6d2609e0e82417de7cc6be47223f576592c656c73c7524d89d"
  end
  resource "XString" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/XString-0.005.tar.gz"
    sha256 "f247f55c19aee6ba4a1ae73c0804259452e02ea85a9be07f8acf700a5138f884"
  end
  resource "Specio" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.47.tar.gz"
    sha256 "f41307f14444f8777e572f27eeb6a964084399e7e382c47c577827ad8a286a1c"
  end
  resource "Params::ValidationCompiler" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.30.tar.gz"
    sha256 "dc5bee23383be42765073db284bed9fbd819d4705ad649c20b644452090d16cb"
  end
  resource "Path::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.118.tar.gz"
    sha256 "32138d8d0f4c9c1a84d2a8f91bc5e913d37d8a7edefbb15a10961bfed560b0fd"
  end
  resource "DateTime::Locale" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.32.tar.gz"
    sha256 "78eabec73d13e1a23b0afcd1b05e84e3196258b98d1bbfafbad90d47db9c6679"
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
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/List-SomeUtils-0.58.tar.gz"
    sha256 "96eafb359339d22bf2a2de421298847a3c40f6a28b6d44005d0965da86a5469d"
  end
  resource "List::UtilsBy" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/List-UtilsBy-0.11.tar.gz"
    sha256 "faddf43b4bc21db8e4c0e89a26e5f23fe626cde3491ec651b6aa338627f5775a"
  end
  resource "Scalar::List::Utils" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.60.tar.gz"
    sha256 "c685bad8021f008f321288b7c3182ec724ab198a77610e877c86f3fad4b85f07"
  end
  resource "List::AllUtils" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/List-AllUtils-0.19.tar.gz"
    sha256 "30a8146ab21a7787b8c56d5829cf9a7f2b15276d3b3fca07336ac38d3002ffbc"
  end
  resource "DateTime::TimeZone" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.49.tar.gz"
    sha256 "01717ec4180b46c321e62e360200f32a99181686bff6eac7a93bf2507a0a1552"
  end
  resource "DateTime" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-1.54.tar.gz"
    sha256 "b12eda6d900713f227964dc4dc0e2efb86d294e8bc2f16be9e95b659f953b2e7"
  end
  resource "DateTime::Calendar::Julian" do
    url "https://cpan.metacpan.org/authors/id/W/WY/WYANT/DateTime-Calendar-Julian-0.106.tar.gz"
    sha256 "faafa769a5e70ff1b584f6e2ef16561588d88c74bc336bddc1aa00f3381ba86c"
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
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/File-Slurper-0.012.tar.gz"
    sha256 "4efb2ea416b110a1bda6f8133549cc6ea3676402e3caf7529fce0313250aa578"
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
    url "https://cpan.metacpan.org/authors/id/A/AL/ALINKE/Lingua-Translit-0.28.tar.gz"
    sha256 "113f91d8fc2c630437153a49fb7a52b023af8f6278ed96c070b1f60824b8eae1"
  end
  resource "Log::Log4perl" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/Log-Log4perl-1.54.tar.gz"
    sha256 "bbabe42d3b4cdaa3a47666b957be81d55bbd1cbcffcdff2b119586d33602eabe"
  end
  resource "Mozilla::CA" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABH/Mozilla-CA-20211001.tar.gz"
    sha256 "122c8900000a9d388aa8e44f911cab6c118fe8497417917a84a8ec183971b449"
  end
  resource "Net::SSLeay" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.92.tar.gz"
    sha256 "47c2f2b300f2e7162d71d699f633dd6a35b0625a00cbda8c50ac01144a9396a9"
  end
  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.09.tar.gz"
    sha256 "03e63ada499d2645c435a57551f041f3943970492baa3b3338246dab6f1fae0a"
  end
  resource "IO::Socket::SSL" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.072.tar.gz"
    sha256 "b5bee81db3905a9069340a450a48e1e1b32dec4ede0064f5703bafb9a707b89d"
  end
  resource "Encode::Locale" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
    sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
  end
  resource "Time::Date" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
    sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
  end
  resource "HTTP::Date" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
    sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
  end
  resource "File::Listing" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.14.tar.gz"
    sha256 "15b3a4871e23164a36f226381b74d450af41f12cc94985f592a669fcac7b48ff"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.33.tar.gz"
    sha256 "23b967f71b852cb209ec92a1af6bac89a141dff1650d69824d29a345c1eceef7"
  end
  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.76.tar.gz"
    sha256 "64d9e2eb2b420f1492da01ec0e6976363245b4be9290f03f10b7d2cb63fa2f61"
  end
  resource "HTTP::Cookies" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.10.tar.gz"
    sha256 "e36f36633c5ce6b5e4b876ffcf74787cc5efe0736dd7f487bdd73c14f0bd7007"
  end
  resource "HTTP::Daemon" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Daemon-6.12.tar.gz"
    sha256 "df47bed10c38670c780fd0116867d5fd4693604acde31ba63380dce04c4e1fa6"
  end
  resource "HTTP::Negotiate" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end
  resource "Net::HTTP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.21.tar.gz"
    sha256 "375aa35b76be99f06464089174d66ac76f78ce83a5c92a907bbfab18b099eec4"
  end
  resource "WWW::RobotRules" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end
  resource "LWP::Protocol::http" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.57.tar.gz"
    sha256 "30c242359cb808f3fe2b115fb90712410557f0786ad74844f9801fd719bc42f8"
  end
  resource "LWP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.57.tar.gz"
    sha256 "30c242359cb808f3fe2b115fb90712410557f0786ad74844f9801fd719bc42f8"
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
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/PerlIO-utf8_strict-0.008.tar.gz"
    sha256 "5f798ded50dcc7d421b57850f837310666d817f4c67c15ba0f5a1d38c74df459"
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
    url "https://cpan.metacpan.org/authors/id/A/AM/AMBS/Text-BibTeX-0.88.tar.gz"
    sha256 "b014586e68bdbcafb0a2cfa0401eb0a04ea5de8c4d5bc36dd0f7faeab6acf42c"
  end
  resource "Text::CSV" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/Text-CSV-2.01.tar.gz"
    sha256 "2a90a5eea3f22c40b87932a929621680609ab5f6b874a77c4134c8a04eb8e74b"
  end
  resource "Text::CSV_XS" do
    url "https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/Text-CSV_XS-1.46.tgz"
    sha256 "27e39f0d5f2322aaf78ff90eb1221f3cbed1d4c514d0956bda19407fcb98bed6"
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
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/MIME-Charset-1.012.2.tar.gz"
    sha256 "878c779c0256c591666bd06c0cde4c0d7820eeeb98fd1183082aee9a1e7b1d13"
  end
  resource "Unicode::LineBreak" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end
  resource "FFI::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/FFI-CheckLib-0.28.tar.gz"
    sha256 "cf377ce735b332c41f600ca6c5e87af30db6c3787f9b67d50a245d1ebe6fc350"
  end
  resource "File::chdir" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1010.tar.gz"
    sha256 "efc121f40bd7a0f62f8ec9b8bc70f7f5409d81cd705e37008596c8efc4452b01"
  end
  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end
  resource "Alien::Build" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.42.tar.gz"
    sha256 "517c99c69fd236e106c1827896bd8562d7768043cc11bfbc399d55e95a63b791"
  end
  resource "Alien::Libxml2" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.17.tar.gz"
    sha256 "73b45244f0b5c36e5332c33569b82a1ab2c33e263f1d00785d2003bcaec68db3"
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
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0207.tar.gz"
    sha256 "903436c9859875bef5593243aae85ced329ad0fb4b57bbf45975e32547c50c15"
  end
  resource "XML::LibXML::Simple" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/XML-LibXML-Simple-1.01.tar.gz"
    sha256 "cd98c8104b70d7672bfa26b4513b78adf2b4b9220e586aa8beb1a508500365a6"
  end
  resource "XML::LibXSLT" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXSLT-1.99.tar.gz"
    sha256 "127e17a877fb61e47b9e8b87bf8daad31339a62a00121f9751d522b438b0f7f0"
  end
  resource "XML::Writer" do
    url "https://cpan.metacpan.org/authors/id/J/JO/JOSEPHW/XML-Writer-0.900.tar.gz"
    sha256 "73c8f5bd3ecf2b350f4adae6d6676d52e08ecc2d7df4a9f089fa68360d400d1f"
  end
  resource "autovivification" do
    url "https://cpan.metacpan.org/authors/id/V/VP/VPIT/autovivification-0.18.tar.gz"
    sha256 "2d99975685242980d0a9904f639144c059d6ece15899efde4acb742d3253f105"
  end

  # Fix Perl 5.36.0 compatibility
  # Remove in the next release
  # See https://github.com/plk/biber/pull/411
  patch do
    url "https://github.com/plk/biber/commit/760e6e4ec08a3097f7e6136331541a7b8c1c9df7.patch?full_index=1"
    sha256 "68586264731e1583331ada69151026333a48b53ab90786f43c36ecac0807d32e"
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
