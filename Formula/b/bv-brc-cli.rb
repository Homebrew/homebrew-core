class BvBrcCli < Formula
  desc "BV-BRC Command-line Interface"
  homepage "https://www.bv-brc.org/"
  url "https://github.com/BV-BRC/BV-BRC-CLI/releases/download/1.043/BV-BRC-CLI-1.043.tgz"
  sha256 "3e72eeb32bf06b465b5751a614216e34eab094663fc3885c0ee74822aee3d224"
  license "MIT"

  depends_on "bowtie2"
  depends_on "perl"

  resource "Digest::Perl::MD5" do
    url "https://cpan.metacpan.org/authors/id/D/DE/DELTA/Digest-Perl-MD5-1.9.tar.gz"
    sha256 "7100cba1710f45fb0e907d8b1a7bd8caef35c64acd31d7f225aff5affeecd9b1"
  end
  resource "Parse::Yapp" do
    url "https://cpan.metacpan.org/authors/id/W/WB/WBRASWELL/Parse-Yapp-1.21.tar.gz"
    sha256 "3810e998308fba2e0f4f26043035032b027ce51ce5c8a52a8b8e340ca65f13e5"
  end
  resource "Text::Glob" do
    url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/Text-Glob-0.11.tar.gz"
    sha256 "069ccd49d3f0a2dedb115f4bdc9fbac07a83592840953d1fcdfc39eb9d305287"
  end
  resource "Test::Harness" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.50.tar.gz"
    sha256 "79b6acdc444f1924cd4c2e9ed868bdc6e09580021aca8ff078ede2ffef8a6f54"
  end
  resource "Stream::Buffered" do
    url "https://cpan.metacpan.org/authors/id/D/DO/DOY/Stream-Buffered-0.03.tar.gz"
    sha256 "9b2d4390b5de6b0cf4558e4ad04317a73c5e13dd19af29149c4e47c37fb2423b"
  end
  resource "Carp::Clan" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Carp-Clan-6.08.tar.gz"
    sha256 "c75f92e34422cc5a65ab05d155842b701452434e9aefb649d6e2289c47ef6708"
  end
  resource "Compress::Raw::Bzip2" do
    url "https://cpan.metacpan.org/authors/id/P/PM/PMQS/Compress-Raw-Bzip2-2.213.tar.gz"
    sha256 "8d75d3d366c9101ca18061b00d438d3da39478c06159147dea3c666770577c7b"
  end
  resource "YAML" do
    url "https://cpan.metacpan.org/authors/id/I/IN/INGY/YAML-1.31.tar.gz"
    sha256 "a0ce30381657dce8e694df9a09e95d818d13beb03698fd2cf79d0c8d564a9b8e"
  end
  resource "XML::SAX::Base" do
    url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz"
    sha256 "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0"
  end
  resource "Data::Dumper" do
    url "https://cpan.metacpan.org/authors/id/N/NW/NWCLARK/Data-Dumper-2.183.tar.gz"
    sha256 "e42736890b7dae1b37818d9c5efa1f1fdc52dec04f446a33a4819bf1d4ab5ad3"
  end
  resource "if" do
    url "https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/if-0.0608.tar.gz"
    sha256 "37206e10919c4d99273020008a3581bf0947d364e859b8966521c3145b4b3700"
  end
  resource "Test::Unit::Debug" do
    url "https://cpan.metacpan.org/authors/id/D/DE/DEXTER/Test-Unit-Lite-0.1202.tar.gz"
    sha256 "351d25ee7131628aaf7e3995fe1fffb893ae7fe6ef58cf3370ed320953f5b2a8"
  end
  resource "common::sense" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/common-sense-3.75.tar.gz"
    sha256 "a86a1c4ca4f3006d7479064425a09fa5b6689e57261fcb994fe67d061cba0e7e"
  end
  resource "version" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/version-0.9933.tar.gz"
    sha256 "dc07d9388ca3d3f67146312904bcdb35fe416bb30056158f80df3281a94fae58"
  end
  resource "Crypt::URandom" do
    url "https://cpan.metacpan.org/authors/id/D/DD/DDICK/Crypt-URandom-0.53.tar.gz"
    sha256 "38ca8a9a26df0ec5f2bc5fcfbdc0021f865963e9221adb4518c57a5004a034a4"
  end
  resource "Filesys::Notify::Simple" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/Filesys-Notify-Simple-0.14.tar.gz"
    sha256 "1fda712d4ba5e1868159ed35f6f8efbfae9d435d6376f5606d533bcb080555a4"
  end
  resource "TimeDate" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
    sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
  end
  resource "HTML::QuickTable" do
    url "https://cpan.metacpan.org/authors/id/N/NW/NWIGER/HTML-QuickTable-1.12.tar.gz"
    sha256 "f7e5523fa2f14f973a67ff66b52dc8069ed80431a10c47bc17e684997605eb75"
  end
  resource "MRO::Compat" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/MRO-Compat-0.15.tar.gz"
    sha256 "0d4535f88e43babd84ab604866215fc4d04398bd4db7b21852d4a31b1c15ef61"
  end
  resource "OLE::Storage_Lite::PPS" do
    url "https://cpan.metacpan.org/authors/id/J/JM/JMCNAMARA/OLE-Storage_Lite-0.22.tar.gz"
    sha256 "d0566d6c29d397ea736379dc515c36849f6b97107cf700ba8250505c984cf965"
  end
  resource "HTML::Table" do
    url "https://cpan.metacpan.org/authors/id/A/AJ/AJPEACOCK/HTML-Table-2.08a.tar.gz"
    sha256 "f6dd9066cde6a818a2c0eb2bcfdb6e5ef3de030fff6beeadfff3732ef1c32805"
  end
  resource "Hash::MultiValue" do
    url "https://cpan.metacpan.org/authors/id/A/AR/ARISTOTLE/Hash-MultiValue-0.16.tar.gz"
    sha256 "66181df7aa68e2786faf6895c88b18b95c800a8e4e6fb4c07fd176410a3c73f4"
  end
  resource "Crypt::RC4" do
    url "https://cpan.metacpan.org/authors/id/S/SI/SIFUKURT/Crypt-RC4-2.02.tar.gz"
    sha256 "5ec4425c6bc22207889630be7350d99686e62a44c6136960110203cd594ae0ea"
  end
  resource "HTML::Tagset" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz"
    sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
  end
  resource "Redis::hiredis" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEOPHENIX/Redis-hiredis-0.11.0.tar.gz"
    sha256 "cee8726bfe0374f76ca1103eca6009d0cd5e677c46f1b93d24a9d68ab2fa9598"
  end
  resource "Scalar::List::Utils" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.68.tar.gz"
    sha256 "23317e4346fe8747f0167eccd1881d6369aa71023f014cd6f846988843295906"
  end
  resource "Unicode::EastAsianWidth" do
    url "https://cpan.metacpan.org/authors/id/A/AU/AUDREYT/Unicode-EastAsianWidth-12.0.tar.gz"
    sha256 "2a5bfd926c4fe5f77e6137da2c31ac2545282ae5fec6e9af0fdd403555a90ff4"
  end
  resource "Term::ReadKey" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
    sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
  end
  resource "Template::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Template-Tiny-1.14.tar.gz"
    sha256 "819cfab6044483cfe28ceb287fddfc3176a2025b1b6f0e980b2dcc26d2269b4c"
  end
  resource "Term::ANSIColor" do
    url "https://cpan.metacpan.org/authors/id/R/RR/RRA/Term-ANSIColor-5.01.tar.gz"
    sha256 "6281bd87cced7a885c38aa104498e3cd4b5f4c276087442cf68c67379318f27d"
  end
  resource "Role::Tiny" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.002004.tar.gz"
    sha256 "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45"
  end
  resource "Proc::ParallelLoop" do
    url "https://cpan.metacpan.org/authors/id/B/BD/BDARRAH/Proc-ParallelLoop-0.5.tgz"
    sha256 "a02da63a14a35113286fc130c52e4f9301010e1e1cf2cb388ae234c8ef89ce42"
  end
  resource "Algorithm::C3" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Algorithm-C3-0.11.tar.gz"
    sha256 "aaf48467765deea6e48054bc7d43e46e4d40cbcda16552c629d37be098289309"
  end
  resource "Filter::tee" do
    url "https://cpan.metacpan.org/authors/id/R/RU/RURBAN/Filter-1.64.tar.gz"
    sha256 "13e7fb7e1d326598e3660103cf1974bee9f690ac5b43b339f2c022f2b5fcef2c"
  end
  resource "parent" do
    url "https://cpan.metacpan.org/authors/id/C/CO/CORION/parent-0.244.tar.gz"
    sha256 "149a65f019909c289714b57fb5c7cadba593e7b86ccf25cb49f7e54a2a1af1ce"
  end
  resource "Carp::Always" do
    url "https://cpan.metacpan.org/authors/id/F/FE/FERREIRA/Carp-Always-0.16.tar.gz"
    sha256 "98aa11492171c016fb0827581ab1fa5ed01b1e99c6357489ddf3a827315866f1"
  end
  resource "Clone" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.47.tar.gz"
    sha256 "4c2c0cb9a483efbf970cb1a75b2ca75b0e18cb84bcb5c09624f86e26b09c211d"
  end
  resource "XSLoader" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SAPER/XSLoader-0.24.tar.gz"
    sha256 "e819a35a6b8e55cb61b290159861f0dc00fe9d8c4f54578eb24f612d45c8d85f"
  end
  resource "Exporter::Tiny" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.006002.tar.gz"
    sha256 "6f295e2cbffb1dbc15bdb9dadc341671c1e0cd2bdf2d312b17526273c322638d"
  end
  resource "Devel::PPPort" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Devel-PPPort-3.68.tar.gz"
    sha256 "5290d5bb84cde9e9e61113a20c67b5d47267eb8e65a119a8a248cc96aac0badb"
  end
  resource "Data::Match" do
    url "https://cpan.metacpan.org/authors/id/K/KS/KSTEPHENS/Data-Match-0.06.tar.gz"
    sha256 "3a2025e51dade63195ac6f4c83858f8075c3d8f26588be42c80ddde474f3c461"
  end
  resource "Canary::Stability" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/Canary-Stability-2013.tar.gz"
    sha256 "a5c91c62cf95fcb868f60eab5c832908f6905221013fea2bce3ff57046d7b6ea"
  end
  resource "boolean" do
    url "https://cpan.metacpan.org/authors/id/I/IN/INGY/boolean-0.46.tar.gz"
    sha256 "95c088085c3e83bf680fe6ce16d8264ec26310490f7d1680e416ea7a118f156a"
  end
  resource "Class::Data::Inheritable" do
    url "https://cpan.metacpan.org/authors/id/R/RS/RSHERER/Class-Data-Inheritable-0.10.tar.gz"
    sha256 "aa1ae68a611357b7bfd9a2f64907cc196ddd6d047cae64ef9d0ad099d98ae54a"
  end
  resource "Sub::Exporter::Progressive" do
    url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
    sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
  end
  resource "Digest::SHA" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSHELOR/Digest-SHA-6.04.tar.gz"
    sha256 "ee91f8f7db894ee7c6ee003daac10a99056c4948a674ef46acdbb63c81a4abeb"
  end
  resource "Locale::Maketext::Simple" do
    url "https://cpan.metacpan.org/authors/id/J/JE/JESSE/Locale-Maketext-Simple-0.21.tar.gz"
    sha256 "b009ff51f4fb108d19961a523e99b4373ccf958d37ca35bf1583215908dca9a9"
  end
  resource "Ref::Util" do
    url "https://cpan.metacpan.org/authors/id/A/AR/ARC/Ref-Util-0.204.tar.gz"
    sha256 "415fa73dbacf44f3d5d79c14888cc994562720ab468e6f71f91cd1f769f105e1"
  end
  resource "Config::Simple" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHERZODR/Config-Simple-4.58.tar.gz"
    sha256 "dd9995706f0f9384a15ccffe116c3b6e22f42ba2e58d8f24ed03c4a0e386edb4"
  end
  resource "IO::SessionData" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/IO-SessionData-1.03.tar.gz"
    sha256 "64a4712a3edbb3fd10230db296c29c8c66f066adfbc0c3df6a48258fef392ddd"
  end
  resource "Data::Traverse" do
    url "https://cpan.metacpan.org/authors/id/F/FR/FRIEDO/Data-Traverse-0.03.tar.gz"
    sha256 "dd992ad968bcf698acf9fd397601ef23d73c59068a6227ba5d3055fd186af16f"
  end
  resource "Compress::Raw::Zlib" do
    url "https://cpan.metacpan.org/authors/id/P/PM/PMQS/Compress-Raw-Zlib-2.213.tar.gz"
    sha256 "56b21c99cb3a3a7f7876a74dd05daa3f41fc9143ddd4dc98f8e46710a106af45"
  end
  resource "Data::Dumper::Concise" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Data-Dumper-Concise-2.023.tar.gz"
    sha256 "a6c22f113caf31137590def1b7028a7e718eface3228272d0672c25e035d5853"
  end
  resource "XML::NamespaceSupport" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz"
    sha256 "47e995859f8dd0413aa3f22d350c4a62da652e854267aa0586ae544ae2bae5ef"
  end
  resource "Net::Cmd" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHAY/libnet-3.15.tar.gz"
    sha256 "a71f4db580e1a767d6936faa5baf38f1fa617824342da078b561283e86f8f4a2"
  end
  resource "Cwd" do
    url "https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/PathTools-3.75.tar.gz"
    sha256 "a558503aa6b1f8c727c0073339081a77888606aa701ada1ad62dd9d8c3f945a2"
  end
  resource "Eval::Closure" do
    url "https://cpan.metacpan.org/authors/id/D/DO/DOY/Eval-Closure-0.14.tar.gz"
    sha256 "ea0944f2f5ec98d895bef6d503e6e4a376fea6383a6bc64c7670d46ff2218cad"
  end
  resource "CPAN::Meta::YAML" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/CPAN-Meta-YAML-0.020.tar.gz"
    sha256 "36c45e0e954fb6d9e4b71ce3da4a244157439969a3af12c515909d7d6c053b2c"
  end
  resource "Sub::Uplevel" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Sub-Uplevel-0.2800.tar.gz"
    sha256 "b4f3f63b80f680a421332d8851ddbe5a8e72fcaa74d5d1d98f3c8cc4a3ece293"
  end
  resource "MIME::Base64" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/MIME-Base64-3.16.tar.gz"
    sha256 "77f73d6f7aeb8d33be08b0d8c2617f9b6c77fb7fc45422d507ca8bafe4246017"
  end
  resource "Attribute::Handlers" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Attribute-Handlers-0.99.tar.gz"
    sha256 "937ea3ebfc9b14f4a4148bf3c32803709edbd12a387137a26370b38ee1fc9835"
  end
  resource "Term::Table" do
    url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Term-Table-0.024.tar.gz"
    sha256 "52288538c3b0514bcd2b61f645686c256619e56a421ae992e2b76d31927c4ece"
  end
  resource "Pod::Escapes" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Pod-Escapes-1.07.tar.gz"
    sha256 "dbf7c827984951fb248907f940fd8f19f2696bc5545c0a15287e0fbe56a52308"
  end
  resource "Type::Tiny" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Type-Tiny-2.006000.tar.gz"
    sha256 "4c685ebbba5145dc02944c305e8e82759811032a55e6da270a751b63b76500ea"
  end
  resource "Perl::OSType" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Perl-OSType-1.010.tar.gz"
    sha256 "e7ed4994b5d547cb23aadb84dc6044c5eb085d5a67a6c5624f42542edd3403b2"
  end
  resource "String::TtyLength" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/String-TtyLength-0.03.tar.gz"
    sha256 "4fedaf72028511d80eb6afba523993e9aaa245d7af558345d5d4ed46e2e82ce1"
  end
  resource "Data::Walk" do
    url "https://cpan.metacpan.org/authors/id/G/GU/GUIDO/Data-Walk-2.01.tar.gz"
    sha256 "88461561839fcbfebe1121cebee9bade20e609a12f8c7cb386eac22c8c54334a"
  end
  resource "CPAN::Meta::Requirements" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/CPAN-Meta-Requirements-2.143.tar.gz"
    sha256 "6ec7e4697bb5a8cea0ee3c8bd5d4b20ce086168a8084778d6e7a4c37356fdf8b"
  end
  resource "Sub::Name" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Sub-Name-0.28.tar.gz"
    sha256 "39c53f6b3b02cbc73176564413b51d3c0f375f9760983fd579c27f558b169cfc"
  end
  resource "Time::Duration::Parse" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Time-Duration-Parse-0.16.tar.gz"
    sha256 "1084a6463ee2790f99215bd76b135ca45afe2bfa6998fa6fd5470b69e1babc12"
  end
  resource "AnyEvent" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/AnyEvent-7.17.tar.gz"
    sha256 "50beea689c098fe4aaeb83806c40b9fe7f946d5769acf99f849f099091a4b985"
  end
  resource "Text::Balanced" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHAY/Text-Balanced-2.06.tar.gz"
    sha256 "773e0f0f21c0cb2cf664cee6ba28ff70259babcc892f9b650f9cbda00be092ad"
  end
  resource "Sub::Quote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006008.tar.gz"
    sha256 "94bebd500af55762e83ea2f2bc594d87af828072370c7110c60c238a800d15b2"
  end
  resource "MIME::Base32" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/MIME-Base32-1.303.tar.gz"
    sha256 "ab21fa99130e33a0aff6cdb596f647e5e565d207d634ba2ef06bdbef50424e99"
  end
  resource "LWP::MediaTypes" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
    sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
  end
  resource "Storable" do
    url "https://cpan.metacpan.org/authors/id/N/NW/NWCLARK/Storable-3.25.tar.gz"
    sha256 "e1e96b24a076792fde52154789fe4b76034b9ad39c8a1a819ead77d50d5f1817"
  end
  resource "autodie" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/autodie-2.37.tar.gz"
    sha256 "4921d211b0cea63c2ca06dfc0c948a7203a3d48ad80a06f43b46104354f2c1c3"
  end
  resource "Types::Serialiser" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/Types-Serialiser-1.01.tar.gz"
    sha256 "f8c7173b0914d0e3d957282077b366f0c8c70256715eaef3298ff32b92388a80"
  end
  resource "Devel::GlobalDestruction" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Devel-GlobalDestruction-0.14.tar.gz"
    sha256 "34b8a5f29991311468fe6913cadaba75fd5d2b0b3ee3bb41fe5b53efab9154ab"
  end
  resource "EV" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/EV-4.34.tar.gz"
    sha256 "1211683dce7b6771f4ab710cc153712bdd77ba6157a13294d0bb73491fd06560"
  end
  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.32.tar.gz"
    sha256 "ef2d6cab0bad18e3ab1c4e6125cc5f695c7e459899f512451c8fa3ef83fa7fc0"
  end
  resource "Class::Singleton" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHAY/Class-Singleton-1.6.tar.gz"
    sha256 "27ba13f0d9512929166bbd8c9ef95d90d630fc80f0c9a1b7458891055e9282a4"
  end
  resource "UUID::URandom" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/UUID-URandom-0.001.tar.gz"
    sha256 "3f13631b13b9604fb489e2989490c99f103743a837239bdafae9d6baf55f8f46"
  end
  resource "Package::Stash::XS" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-XS-0.30.tar.gz"
    sha256 "26bad65c1959c57379b3e139dc776fbec5f702906617ef27cdc293ddf1239231"
  end
  resource "Sub::Install" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Sub-Install-0.929.tar.gz"
    sha256 "80b1e281d8cd3b2b31dac711f5c8a1657a87cd80bbe69af3924bcbeb4e5db077"
  end
  resource "YAML::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.76.tar.gz"
    sha256 "a8d584394cf069bf8f17cba3dd5099003b097fce316c31fb094f1b1c171c08a3"
  end
  resource "Safe::Isa" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Safe-Isa-1.000010.tar.gz"
    sha256 "87f4148aa0ff1d5e652723322eab7dafa3801c967d6f91ac9147a3c467b8a66a"
  end
  resource "Math::BigInt" do
    url "https://cpan.metacpan.org/authors/id/P/PJ/PJACKLAM/Math-BigInt-2.003004.tar.gz"
    sha256 "71f37d114d9403755fed1ad1433a190efd89f339e2531da701d500e6d8244611"
  end
  resource "Math::Round" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Math-Round-0.08.tar.gz"
    sha256 "7b4d2775ad3b859a5fd61f7f3fc5cfba42b1a10df086d2ed15a0ae712c8fd402"
  end
  resource "Class::C3" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Class-C3-0.35.tar.gz"
    sha256 "84053cf1a68fcc8c12056c2f120adf04f7f68e3be34f4408e95d026fee67e33e"
  end
  resource "HTTP::Date" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
    sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
  end
  resource "Log::Log4perl" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/Log-Log4perl-1.57.tar.gz"
    sha256 "0f8fcb7638a8f3db4c797df94fdbc56013749142f2f94cbc95b43c9fca096a13"
  end
  resource "Devel::StackTrace" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.05.tar.gz"
    sha256 "63cb6196e986a7e578c4d28b3c780e7194835bfc78b68eeb8f00599d4444888c"
  end
  resource "IO::Stringy" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/IO-Stringy-2.113.tar.gz"
    sha256 "51220fcaf9f66a639b69d251d7b0757bf4202f4f9debd45bdd341a6aca62fe4e"
  end
  resource "Pod::Simple" do
    url "https://cpan.metacpan.org/authors/id/K/KH/KHW/Pod-Simple-3.45.tar.gz"
    sha256 "8483bb95cd3e4307d66def092a3779f843af772482bfdc024e3e00d0c4db0cfa"
  end
  resource "Test" do
    url "https://cpan.metacpan.org/authors/id/J/JE/JESSE/Test-1.26.tar.gz"
    sha256 "f7701bd28e05e7f82fe9a181bbab38f53fa6aeae48d2a810da74d1b981d4f392"
  end
  resource "AnyEvent::HTTP" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/AnyEvent-HTTP-2.25.tar.gz"
    sha256 "5cfa53416124176f6f4cd32b00ea8ca79a2d5df51258683989cd04fe86e25013"
  end
  resource "bignum" do
    url "https://cpan.metacpan.org/authors/id/P/PJ/PJACKLAM/bignum-0.67.tar.gz"
    sha256 "1c9a824ab323e3e58d9808011c10ad27589dba1202806278215012ca7f522875"
  end
  resource "HTTP::Tiny" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/HTTP-Tiny-0.090.tar.gz"
    sha256 "faaf60b3f9baf4b8f703632aba223648aaa58b0107e64ca515ed00247978d83e"
  end
  resource "Unicode::Normalize" do
    url "https://cpan.metacpan.org/authors/id/K/KH/KHW/Unicode-Normalize-1.26.tar.gz"
    sha256 "bade6f74e89b95a4b2226a0965ac1218e0e4eeaa0edb4b30ee7aac9d5dae773f"
  end
  resource "Clone::Choose" do
    url "https://cpan.metacpan.org/authors/id/H/HE/HERMES/Clone-Choose-0.010.tar.gz"
    sha256 "5623481f58cee8edb96cd202aad0df5622d427e5f748b253851dfd62e5123632"
  end
  resource "Filter::Simple" do
    url "https://cpan.metacpan.org/authors/id/S/SM/SMUELLER/Filter-Simple-0.94.tar.gz"
    sha256 "cffc0b960d783dfbcf7b247f5fea65c84de230ee2f091f142ca9b8aeb07e79d2"
  end
  resource "Hash::Merge::Simple" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Hash-Merge-Simple-0.052.tar.gz"
    sha256 "c27f20895814a96e0c5bd0ca3315bf901d79706e3bab4ab0d946debc2c429c0b"
  end
  resource "Text::Table::Tiny" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Text-Table-Tiny-1.03.tar.gz"
    sha256 "0b5a8c2678f79e99694055684f55f134b5fffb7ae5f0016a4e48661403c6de5e"
  end
  resource "Test::Simple" do
    url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302209.tar.gz"
    sha256 "dde1a388b94e178808039361f6393c7195f72518c39967a7a3582299b8c39e3e"
  end
  resource "File::Listing" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.16.tar.gz"
    sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
  end
  resource "JSON::XS" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/JSON-XS-4.03.tar.gz"
    sha256 "515536f45f2fa1a7e88c8824533758d0121d267ab9cb453a1b5887c8a56b9068"
  end
  resource "Task::Weaken" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Task-Weaken-1.06.tar.gz"
    sha256 "2383fedb9dbaef646468ea824afbf7c801076720cfba0df2a7a074726dcd66be"
  end
  resource "Digest" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/Digest-1.20.tar.gz"
    sha256 "72f55db5c21b808607cb38f75f9b9d5d0bfcb9bd5aa636568db7488f04de689a"
  end
  resource "Encode" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DANKOGAI/Encode-3.21.tar.gz"
    sha256 "eacf71c5eb49e0e590de797f1982d7fb95d8481e4d13c3ce79eb32ef9373b3db"
  end
  resource "Crypt::OpenSSL::Guess" do
    url "https://cpan.metacpan.org/authors/id/A/AK/AKIYM/Crypt-OpenSSL-Guess-0.15.tar.gz"
    sha256 "1c5033381819fdb4c9087dd291b90ec70e7810d31d57eade9b388eccfd70386d"
  end
  resource "PBKDF2::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/PBKDF2-Tiny-0.005.tar.gz"
    sha256 "b4e21dc59b30265eaaa41b705087ec03447d9c655a14ac40ff46e4de29eabf8e"
  end
  resource "AnyEvent::Run" do
    url "https://cpan.metacpan.org/authors/id/A/AG/AGRUNDMA/AnyEvent-Run-0.01.tar.gz"
    sha256 "9bee0ccfd5f91fe071e0922e1583333154d0b5a0d4e6561be00ba56815451423"
  end
  resource "Proc::ProcessTable" do
    url "https://cpan.metacpan.org/authors/id/J/JW/JWB/Proc-ProcessTable-0.636.tar.gz"
    sha256 "944224ffb00fc1ef35069633770a0afda8623b5c7532d1e4ab48a9df394890fd"
  end
  resource "File::Copy::Recursive" do
    url "https://cpan.metacpan.org/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.45.tar.gz"
    sha256 "d3971cf78a8345e38042b208bb7b39cb695080386af629f4a04ffd6549df1157"
  end
  resource "Encode::Locale" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
    sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
  end
  resource "IO::Compress" do
    url "https://cpan.metacpan.org/authors/id/P/PM/PMQS/IO-Compress-2.213.tar.gz"
    sha256 "ae4d01ae574e4568c5f2fb0573e74631e2720b71ad3bc5a3ffe9480f1cb9a851"
  end
  resource "AppConfig" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/AppConfig-1.71.tar.gz"
    sha256 "1177027025ecb09ee64d9f9f255615c04db5e14f7536c344af632032eb887b0f"
  end
  resource "Devel::StackTrace::AsHTML" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/Devel-StackTrace-AsHTML-0.15.tar.gz"
    sha256 "6283dbe2197e2f20009cc4b449997742169cdd951bfc44cbc6e62c2a962d3147"
  end
  resource "IO::Tty" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IO-Tty-1.20.tar.gz"
    sha256 "b15309fc85623893289cb9b2b88dfa9ed1e69156b75f29938553a45be6d730af"
  end
  resource "Spreadsheet::ParseExcel" do
    url "https://cpan.metacpan.org/authors/id/J/JM/JMCNAMARA/Spreadsheet-ParseExcel-0.66.tar.gz"
    sha256 "bfd76acfba988601dc051bda73b4bb25f6839a006dd960b6a7401c249245f65b"
  end
  resource "Crypt::OpenSSL::Random" do
    url "https://cpan.metacpan.org/authors/id/R/RU/RURBAN/Crypt-OpenSSL-Random-0.17.tar.gz"
    sha256 "a571b24181baaa76c96704e92acffc6934ff593e380dade274db4e43c140ad51"
  end
  resource "Taint::Util" do
    url "https://cpan.metacpan.org/authors/id/A/AV/AVAR/Taint-Util-0.08.tar.gz"
    sha256 "78047c65237ee4ca2451bd8b44936db09a34a3925003eccf4255bcd7fdd9768c"
  end
  resource "Set::Object" do
    url "https://cpan.metacpan.org/authors/id/R/RU/RURBAN/Set-Object-1.42.tar.gz"
    sha256 "d18c5a8a233eabbd0206cf3da5b00fcdd7b37febf12a93dcc3d1c026e6fdec45"
  end
  resource "Module::Metadata" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Module-Metadata-1.000038.tar.gz"
    sha256 "b599d8770a9a9fa0a8ae3cd0ed395a9cf71b4eb53aed82989a6bece33485a9cd"
  end
  resource "JSON::PP" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-PP-4.16.tar.gz"
    sha256 "8bc2f162bafc42645c489905ad72540f0d3c284b360c96299095183c30cc9789"
  end
  resource "Time::HiRes" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Time-HiRes-1.9764.tar.gz"
    sha256 "9841be5587bfb7cd1f2fe267b5e5ac04ce25e79d5cc77e5ef9a9c5abd101d7b1"
  end
  resource "Carp" do
    url "https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/Carp-1.50.tar.gz"
    sha256 "f5273b4e1a6d51b22996c48cb3a3cbc72fd456c4038f5c20b127e2d4bcbcebd9"
  end
  resource "Scope::Guard" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHOCOLATE/Scope-Guard-0.21.tar.gz"
    sha256 "8c9b1bea5c56448e2c3fadc65d05be9e4690a3823a80f39d2f10fdd8f777d278"
  end
  resource "Pod::Parser" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Parser-1.67.tar.gz"
    sha256 "5deccbf55d750ce65588cd211c1a03fa1ef3aaa15d1ac2b8d85383a42c1427ea"
  end
  resource "Module::Load" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Module-Load-0.36.tar.gz"
    sha256 "d825020ac00b220e89f9524e24d838f9438b072fcae8c91938e4026677bef6e0"
  end
  resource "Tie::IxHash" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz"
    sha256 "fabb0b8c97e67c9b34b6cc18ed66f6c5e01c55b257dcf007555e0b027d4caf56"
  end
  resource "Text::CSV" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/Text-CSV-2.05.tar.gz"
    sha256 "c22e19f677b1e40636f9f30a4bd7c9b29d86be4f06e5966c7d505910bcaf6d66"
  end
  resource "IO::HTML" do
    url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
    sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
  end
  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.31.tar.gz"
    sha256 "b9c4d58b2614b8611ae03a95a6d60ed996f4b311ef3cd5a937b92f1825ecc564"
  end
  resource "Hash::Merge" do
    url "https://cpan.metacpan.org/authors/id/H/HE/HERMES/Hash-Merge-0.302.tar.gz"
    sha256 "ae0522f76539608b61dde14670e79677e0f391036832f70a21f31adde2538644"
  end
  resource "base" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/base-2.23.tar.gz"
    sha256 "40f55841299a9fe6fab03cd098f94e9221fb516978e9ef40fd8ff2cbd6625dde"
  end
  resource "Params::Check" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Params-Check-0.38.tar.gz"
    sha256 "f0c9d33876c36b1bca1475276d26d2efaf449b256d7cc8118fae012e89a26290"
  end
  resource "Number::Compare" do
    url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/Number-Compare-0.03.tar.gz"
    sha256 "83293737e803b43112830443fb5208ec5208a2e6ea512ed54ef8e4dd2b880827"
  end
  resource "String::Escape" do
    url "https://cpan.metacpan.org/authors/id/E/EV/EVO/String-Escape-2010.002.tar.gz"
    sha256 "fd645f8b336224d20a85ae7fb1a384576eac329f7adc3923c3241e828e3b9a8a"
  end
  resource "Module::Find" do
    url "https://cpan.metacpan.org/authors/id/C/CR/CRENZ/Module-Find-0.17.tar.gz"
    sha256 "75ff1c8c98e8c0537692645cd62d2a4c48ab097b1d4a5ea42a25305098d7fd39"
  end
  resource "Digest::MD5" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/Digest-MD5-2.59.tar.gz"
    sha256 "b5ecba079bd5907d52663a659cd977b6247526abe6aed9b818d083dd99af77d2"
  end
  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
    sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
  end
  resource "Module::CoreList" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Module-CoreList-5.20250120.tar.gz"
    sha256 "3c5fede981f7576ce25d5d8465e07a1cf748571847c3aac457cae4ad5bcca6f1"
  end
  resource "Parse::RecDescent" do
    url "https://cpan.metacpan.org/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967015.tar.gz"
    sha256 "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37"
  end
  resource "Pod::Man" do
    url "https://cpan.metacpan.org/authors/id/R/RR/RRA/podlators-v6.0.2.tar.gz"
    sha256 "2992125eab7d2b1c5a2b15a26ad7955f7d989eba6c831abdcaf2000e86a91337"
  end
  resource "HTTP::Message" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-7.00.tar.gz"
    sha256 "5afa95eb6ed1c632e81656201a2738e2c1bc6cbfae2f6d82728e2bb0b519c1dc"
  end
  resource "Data::UUID" do
    url "https://cpan.metacpan.org/authors/id/G/GT/GTERMARS/Data-UUID-1.227.tar.gz"
    sha256 "95bda7276265f57bc48ffdeddec5ef28cd6f765e3a183757fa5f09f0ce6b98ac"
  end
  resource "ExtUtils::MakeMaker" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.70.tar.gz"
    sha256 "f108bd46420d2f00d242825f865b0f68851084924924f92261d684c49e3e7a74"
  end
  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end
  resource "Digest::HMAC" do
    url "https://cpan.metacpan.org/authors/id/A/AR/ARODLAND/Digest-HMAC-1.05.tar.gz"
    sha256 "215cb59cba610745cfb2d4b3f8ef756d590e57e3ad7986a992e87c4969fcdc7a"
  end
  resource "ExtUtils::Helpers" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.028.tar.gz"
    sha256 "c8574875cce073e7dc5345a7b06d502e52044d68894f9160203fcaab379514fe"
  end
  resource "Crypt::OpenSSL::RSA" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/Crypt-OpenSSL-RSA-0.33.tar.gz"
    sha256 "bdbe630f6d6f540325746ad99977272ac8664ff81bd19f0adaba6d6f45efd864"
  end
  resource "CPAN::Meta" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/CPAN-Meta-2.150010.tar.gz"
    sha256 "e4f80f2ec73e0741455f957bbfc992b167ecbfa1c9e23ba358df3b37b86ba3d6"
  end
  resource "Module::Load::Conditional" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Module-Load-Conditional-0.74.tar.gz"
    sha256 "54c354a9393820f1ebc2a095da084ea0392dcbccb0cb38a187a71831cc60a730"
  end
  resource "Net::SSLeay" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.94.tar.gz"
    sha256 "9d7be8a56d1bedda05c425306cc504ba134307e0c09bda4a788c98744ebcd95d"
  end
  resource "YAML::LibYAML" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TINITA/YAML-LibYAML-v0.903.0.tar.gz"
    sha256 "67da1d1634101fa0c4b2df0c77cd413b00953425f93a13dac8aa9383049d9c0c"
  end
  resource "File::Temp" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-Temp-0.2311.tar.gz"
    sha256 "2290d61bf5c39882fc3311da9ce1c7f42dbdf825ae169e552c59fe4598b36f4a"
  end
  resource "Context::Preserve" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Context-Preserve-0.03.tar.gz"
    sha256 "09914a4c2c7bdb99cab680c183cbf492ec98d6e23fbcc487fcc4ae10567dfd1f"
  end
  resource "Module::Pluggable" do
    url "https://cpan.metacpan.org/authors/id/S/SI/SIMONW/Module-Pluggable-6.3.tar.gz"
    sha256 "58512bb9c654746d0937770b98b559b30872d85ac24073485e5830890dd1b2a0"
  end
  resource "JSON::MaybeXS" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/JSON-MaybeXS-1.004008.tar.gz"
    sha256 "cd3937afa78831f80a2ad5abab6c51b9e82fca4c31e5856ea208d598db5dc867"
  end
  resource "Exception::Class" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Exception-Class-1.45.tar.gz"
    sha256 "5482a77ef027ca1f9f39e1f48c558356e954936fc8fbbdee6c811c512701b249"
  end
  resource "Class::Method::Modifiers" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Class-Method-Modifiers-2.15.tar.gz"
    sha256 "65cd85bfe475d066e9186f7a8cc636070985b30b0ebb1cde8681cf062c2e15fc"
  end
  resource "WWW::RobotRules" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end
  resource "Class::Inspector" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Class-Inspector-1.36.tar.gz"
    sha256 "cc295d23a472687c24489d58226ead23b9fdc2588e522f0b5f0747741700694e"
  end
  resource "JSON::Any" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/JSON-Any-1.40.tar.gz"
    sha256 "083256255a48094fd9ac1239e0fea8a10a2383a9cd1ef4b1c7264ede1b4400ab"
  end
  resource "File::chdir" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1011.tar.gz"
    sha256 "31ebf912df48d5d681def74b9880d78b1f3aca4351a0ed1fe3570b8e03af6c79"
  end
  resource "File::Find::Rule" do
    url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/File-Find-Rule-0.34.tar.gz"
    sha256 "7e6f16cc33eb1f29ff25bee51d513f4b8a84947bbfa18edb2d3cc40a2d64cafe"
  end
  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.83.tar.gz"
    sha256 "7278ce9791256132b26a71a5719451844704bb9674b58302c3486df43584f8c0"
  end
  resource "XML::SAX" do
    url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-1.02.tar.gz"
    sha256 "4506c387043aa6a77b455f00f57409f3720aa7e553495ab2535263b4ed1ea12a"
  end
  resource "Data::Compare" do
    url "https://cpan.metacpan.org/authors/id/D/DC/DCANTRELL/Data-Compare-1.29.tar.gz"
    sha256 "53c9db3b93263c88aaa3c4072d819eaded024d7a36b38c0c37737d288d5afa8c"
  end
  resource "Module::ScanDeps" do
    url "https://cpan.metacpan.org/authors/id/R/RS/RSCHUPP/Module-ScanDeps-1.37.tar.gz"
    sha256 "1f5e119cade1466c39c71e5bc35a8d4f4e672635db03d79a5a0dcf08c4e2b5a3"
  end
  resource "File::HomeDir" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-HomeDir-1.006.tar.gz"
    sha256 "593737c62df0f6dab5d4122e0b4476417945bb6262c33eedc009665ef1548852"
  end
  resource "Object::InsideOut" do
    url "https://cpan.metacpan.org/authors/id/J/JD/JDHEDDEN/Object-InsideOut-4.05.tar.gz"
    sha256 "9dfd6ca2822724347e0eb6759d00709425814703ad5c66bdb6214579868bcac4"
  end
  resource "Path::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.146.tar.gz"
    sha256 "861ef09bca68254e9ab24337bb6ec9d58593a792e9d68a27ee6bec2150f06741"
  end
  resource "HTTP::Cookies" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.11.tar.gz"
    sha256 "8c9a541a4a39f6c0c7e3d0b700b05dfdb830bd490a1b1942a7dedd1b50d9a8c8"
  end
  resource "FFI::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/FFI-CheckLib-0.31.tar.gz"
    sha256 "04d885fc377d44896e5ea1c4ec310f979bb04f2f18658a7e7a4d509f7e80bb80"
  end
  resource "Template::Toolkit" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/Template-Toolkit-3.102.tar.gz"
    sha256 "d161c89dee9b213a7c55709ea782e2dd5923dbd1215b9576612889e6e74a2e06"
  end
  resource "Params::ValidationCompiler" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.31.tar.gz"
    sha256 "7b6497173f1b6adb29f5d51d8cf9ec36d2f1219412b4b2410e9d77a901e84a6d"
  end
  resource "Capture::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.50.tar.gz"
    sha256 "ca6e8d7ce7471c2be54e1009f64c367d7ee233a2894cacf52ebe6f53b04e81e5"
  end
  resource "Class::C3::Componentised" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Class-C3-Componentised-1.001002.tar.gz"
    sha256 "3051b146dc1efeaea1a9a2e9e6b1773080995b898ab583f155658d5fc80b9693"
  end
  resource "Moo" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Moo-2.005005.tar.gz"
    sha256 "fb5a2952649faed07373f220b78004a9c6aba387739133740c1770e9b1f4b108"
  end
  resource "Spreadsheet::WriteExcel" do
    url "https://cpan.metacpan.org/authors/id/J/JM/JMCNAMARA/Spreadsheet-WriteExcel-2.40.tar.gz"
    sha256 "e356aad6866cf135731268ee0e979a197443c15a04878e9cf3e80d022ad6c07e"
  end
  resource "IO" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IO-1.55.tar.gz"
    sha256 "0443afebb9a48f29611e9b17a017f430b51167a498fa4646c07f8dce03b6b95f"
  end
  resource "Pod::Perldoc" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MALLEN/Pod-Perldoc-3.28.tar.gz"
    sha256 "cc41e605b8e13c40a8ee6504ff46347b5ba7fbd92203b3bb055422051befc64d"
  end
  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end
  resource "Archive::Zip" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/Archive-Zip-1.68.tar.gz"
    sha256 "984e185d785baf6129c6e75f8eb44411745ac00bf6122fb1c8e822a3861ec650"
  end
  resource "Config::Any" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Config-Any-0.33.tar.gz"
    sha256 "c0668eb5f2cd355bf20557f04dc18a25474b7a0bcfa79562e3165d9a3c789333"
  end
  resource "HTTP::Negotiate" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end
  resource "IO::Pager" do
    url "https://cpan.metacpan.org/authors/id/J/JP/JPIERCE/IO-Pager-2.10.tgz"
    sha256 "bcb4d8c2d280c8034b82591cc0b9eb67a004f90ce9aa05979fc6071307acb195"
  end
  resource "File::Slurp" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/File-Slurp-9999.32.tar.gz"
    sha256 "4c3c21992a9d42be3a79dd74a3c83d27d38057269d65509a2f555ea0fb2bc5b0"
  end
  resource "IPC::Cmd" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/IPC-Cmd-1.04.tar.gz"
    sha256 "d110a0f60e35c65721454200f0d2f0f8965529a2add9649d1fa6f4f9eccb6430"
  end
  resource "ExtUtils::Config" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Config-0.010.tar.gz"
    sha256 "82e7e4e90cbe380e152f5de6e3e403746982d502dd30197a123652e46610c66d"
  end
  resource "IO::Socket::SSL" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.089.tar.gz"
    sha256 "f683112c1642967e9149f51ad553eccd017833b2f22eb23a9055609d2e3a14d1"
  end
  resource "Net::HTTP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.23.tar.gz"
    sha256 "0d65c09dd6c8589b2ae1118174d3c1a61703b6ecfc14a3442a8c74af65e0c94e"
  end
  resource "Heap" do
    url "https://cpan.metacpan.org/authors/id/J/JM/JMM/Heap-0.80.tar.gz"
    sha256 "ccda29f3c93176ad0fdfff4dd6f5e4ac90b370cba4b028386b7343bf64139bde"
  end
  resource "Test::NoWarnings" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Test-NoWarnings-1.06.tar.gz"
    sha256 "c2dc51143b7eb63231210e27df20d2c8393772e0a333547ec8b7a205ed62f737"
  end
  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/DBI-1.647.tgz"
    sha256 "0df16af8e5b3225a68b7b592ab531004ddb35a9682b50300ce50174ad867d9aa"
  end
  resource "CGI" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEEJO/CGI-4.67.tar.gz"
    sha256 "f4a6896eb94a3ecaa1c1ba02f7e0d2bed0be4c5ad3378d80196ec25662ac4111"
  end
  resource "Spreadsheet::XLSX" do
    url "https://cpan.metacpan.org/authors/id/A/AS/ASB/Spreadsheet-XLSX-0.18.tar.gz"
    sha256 "fde689da209df6d3ea96009ff3622075c2c09b59d8837e3bdb14805a955156d7"
  end
  resource "ExtUtils::InstallPaths" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.014.tar.gz"
    sha256 "ae65d20cc3c7e14b3cd790915c84510f82dfb37a4c9b88aa74b2e843af417d01"
  end
  resource "ExtUtils::CBuilder" do
    url "https://cpan.metacpan.org/authors/id/A/AM/AMBS/ExtUtils-CBuilder-0.280236.tar.gz"
    sha256 "abc21827eb8a513171bf7fdecefce9945132cb76db945036518291f607b1491f"
  end
  resource "Math::Random::MT::Auto" do
    url "https://cpan.metacpan.org/authors/id/J/JD/JDHEDDEN/Math-Random-MT-Auto-6.23.tar.gz"
    sha256 "58bcb5ad3162964ff5a0c4d2dcbaa0202c2c85d9c470496f3b7a998757776313"
  end
  resource "Excel::Writer::XLSX" do
    url "https://cpan.metacpan.org/authors/id/J/JM/JMCNAMARA/Excel-Writer-XLSX-1.14.tar.gz"
    sha256 "ce9e2c24756ee0bfbc241c66fca62ac4c9e06a1fd0da7fffff8ccb322cbfb688"
  end
  resource "Test::Deep" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Test-Deep-1.204.tar.gz"
    sha256 "b6591f6ccdd853c7efc9ff3c5756370403211cffe46047f082b1cd1611a84e5f"
  end
  resource "Test::Fatal" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Test-Fatal-0.017.tar.gz"
    sha256 "37dfffdafb84b762efe96b02fb2aa41f37026c73e6b83590db76229697f3c4a6"
  end
  resource "Params::Util" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/Params-Util-1.102.tar.gz"
    sha256 "499bb1b482db24fda277a51525596ad092c2bd51dd508fa8fec2e9f849097402"
  end
  resource "File::ShareDir::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.14.tar.gz"
    sha256 "8f9533b198f2d4a9a5288cbc7d224f7679ad05a7a8573745599789428bc5aea0"
  end
  resource "Test::Warn" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BIGJ/Test-Warn-0.37.tar.gz"
    sha256 "98ca32e7f2f5ea89b8bfb9a0609977f3d153e242e2e51705126cb954f1a06b57"
  end
  resource "Test::SharedFork" do
    url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-SharedFork-0.35.tar.gz"
    sha256 "2932e865610e80758f764c586757ef8e11db1284d958e25e4b7a85098414c59f"
  end
  resource "Test::Exception" do
    url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Exception-0.43.tar.gz"
    sha256 "156b13f07764f766d8b45a43728f2439af81a3512625438deab783b7883eb533"
  end
  resource "List::MoreUtils::XS" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz"
    sha256 "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242"
  end
  resource "Pod::Usage" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Usage-2.03.tar.gz"
    sha256 "7d8fdc7dce60087b6cf9e493b8d6ae84a5ab4c0608a806a6d395cc6557460744"
  end
  resource "LWP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.77.tar.gz"
    sha256 "94a907d6b3ea8d966ef43deffd4fa31f5500142b4c00489bfd403860a5f060e4"
  end
  resource "Spreadsheet::Write" do
    url "https://cpan.metacpan.org/authors/id/A/AM/AMALTSEV/Spreadsheet-Write-1.03.tar.gz"
    sha256 "a47dc5590ad3b22359a0094baf1274835dc422a1ca79a5ad521522e6ea522e3c"
  end
  resource "Graph" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/Graph-0.9733.tar.gz"
    sha256 "29f50a274825fa83436b95ac62e5a5a35ac608b660b436ed8635d4be07068271"
  end
  resource "DBD::SQLite" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/DBD-SQLite-1.76.tar.gz"
    sha256 "0a33a7a935be63371071dbe600cfaefa67cd971b67580a917bbf6ebaf723c584"
  end
  resource "Data::UUID::MT" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Data-UUID-MT-1.001.tar.gz"
    sha256 "304c4b98128311f84b7f529c7018ba849c75d3643aa80ea382b4b08057c4672d"
  end
  resource "HTTP::MultiPartParser" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHANSEN/HTTP-MultiPartParser-0.02.tar.gz"
    sha256 "5eddda159f54d16f868e032440ac2b024e55aac48931871b62627f1a16d00b12"
  end
  resource "ExtUtils::ParseXS" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-ParseXS-3.51.tar.gz"
    sha256 "82431a57425d78682acefb3a2cc9287683d091c8d034b825c584d9805bed6535"
  end
  resource "SQL::Abstract" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSTROUT/SQL-Abstract-2.000001.tar.gz"
    sha256 "35a642662c349420d44be6e0ef7d8765ea743eb12ad14399aa3a232bb94e6e9a"
  end
  resource "List::MoreUtils" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz"
    sha256 "63b1f7842cd42d9b538d1e34e0330de5ff1559e4c2737342506418276f646527"
  end
  resource "Data::OptList" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Data-OptList-0.114.tar.gz"
    sha256 "9fd1093b917a21fb79ae1607db53d113b4e0ad8fe0ae776cb077a7e50044fdf3"
  end
  resource "File::ShareDir" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-ShareDir-1.118.tar.gz"
    sha256 "3bb2a20ba35df958dc0a4f2306fc05d903d8b8c4de3c8beefce17739d281c958"
  end
  resource "ExtUtils::CppGuess" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/ExtUtils-CppGuess-0.27.tar.gz"
    sha256 "b2c7b581901054a32dfcea12536fda8626457ed0bfbc02600bd354bde7e2a9b4"
  end
  resource "Alien::Build" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.84.tar.gz"
    sha256 "8e891fd3acbac39dd8fdc01376b9abff931e625be41e0910ca30ad59363b4477"
  end
  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
    sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
  end
  resource "SQL::Abstract::Classic" do
    url "https://cpan.metacpan.org/authors/id/R/RI/RIBASUSHI/SQL-Abstract-Classic-1.91.tar.gz"
    sha256 "4e3d1dfd095b2123268586bb06b86929ea571388d4e941acccbdcda1e108ef28"
  end
  resource "LWP::Protocol::https" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.14.tar.gz"
    sha256 "59cdeabf26950d4f1bef70f096b0d77c5b1c5a7b5ad1b66d71b681ba279cbb2a"
  end
  resource "Sub::Exporter" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Sub-Exporter-0.991.tar.gz"
    sha256 "2a95695d35c5d0d5373a7e145c96b9b016113b74e94116835ac05450cae4d445"
  end
  resource "XML::Parser" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz"
    sha256 "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"
  end
  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.051.tar.gz"
    sha256 "74fdce35e8cd4d787bc2d4fc1d43a291b7bbced4e94dc5fc592bd81ca93a98e9"
  end
  resource "Sub::Exporter::ForMethods" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Sub-Exporter-ForMethods-0.100055.tar.gz"
    sha256 "791f4203ba7c0f7d8380bc01bec20215f7c8bc70d7ed03e552eee44541abe94e"
  end
  resource "Module::Runtime" do
    url "https://cpan.metacpan.org/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz"
    sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
  end
  resource "Path::Class" do
    url "https://cpan.metacpan.org/authors/id/K/KW/KWILLIAMS/Path-Class-0.37.tar.gz"
    sha256 "654781948602386f2cb2e4473a739f17dc6953d92aabc2498a4ca2561bc248ce"
  end
  resource "Text::Aligner" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Text-Aligner-0.16.tar.gz"
    sha256 "5c857dbce586f57fa3d7c4ebd320023ab3b2963b2049428ae01bd3bc4f215725"
  end
  resource "IO::Socket::IP" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/IO-Socket-IP-0.43.tar.gz"
    sha256 "ebf6217f48f537ae9a78126f0ecb4baa3d4820e3e26153ce250f3bffd05f6d0b"
  end
  resource "File::Map" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/File-Map-0.71.tar.gz"
    sha256 "c8e26933804e870d4aba92623b7886ac8b3c760c98fbfcd3bdc4b2305c464759"
  end
  resource "Devel::CheckCompiler" do
    url "https://cpan.metacpan.org/authors/id/S/SY/SYOHEX/Devel-CheckCompiler-0.07.tar.gz"
    sha256 "768b7697b4b8d4d372c7507b65e9dd26aa4223f7100183bbb4d3af46d43869b5"
  end
  resource "File::Remove" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/File-Remove-1.61.tar.gz"
    sha256 "fd857f585908fc503461b9e48b3c8594e6535766bc14beb17c90ba58d5dc4975"
  end
  resource "Cookie::Baker" do
    url "https://cpan.metacpan.org/authors/id/K/KA/KAZEBURO/Cookie-Baker-0.12.tar.gz"
    sha256 "9b04df5d47dcd45ac4299626a10ec990fb40c94ee5a6300c3a88bdfb3575ec29"
  end
  resource "AnyEvent::DBI::MySQL" do
    url "https://cpan.metacpan.org/authors/id/P/PO/POWERMAN/AnyEvent-DBI-MySQL-v2.1.0.tar.gz"
    sha256 "303ccab15c52611902efc8cc2acf3d406dc11543de80e039b25af6061755e08f"
  end
  resource "WWW::Form::UrlEncoded" do
    url "https://cpan.metacpan.org/authors/id/K/KA/KAZEBURO/WWW-Form-UrlEncoded-0.26.tar.gz"
    sha256 "c0480b5f1f15b71163ec327b8e7842298f0cb3ace97e63d7034af1e94a2d90f4"
  end
  resource "Readonly" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SANKO/Readonly-2.05.tar.gz"
    sha256 "4b23542491af010d44a5c7c861244738acc74ababae6b8838d354dfb19462b5e"
  end
  resource "Alien::Build::Plugin::Download::GitLab" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-Plugin-Download-GitLab-0.01.tar.gz"
    sha256 "c1f089c8ea152a789909d48a83dbfcf2626f773daf30431c8622582b26aba902"
  end
  resource "SOAP::Lite" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/SOAP-Lite-1.27.tar.gz"
    sha256 "e359106bab1a45a16044a4c2f8049fad034e5ded1517990bc9b5f8d86dddd301"
  end
  resource "Set::IntervalTree" do
    url "https://cpan.metacpan.org/authors/id/S/SL/SLOYD/Set-IntervalTree-0.12.tar.gz"
    sha256 "6fd4000e4022968e2ce5b83c07b189219ef1925ecb72977b52a6f7d76adbc349"
  end
  resource "REST::Client" do
    url "https://cpan.metacpan.org/authors/id/A/AK/AKHUETTEL/REST-Client-281.tar.gz"
    sha256 "fa10d21a0037e682601efe66738a758ff7521094aa01229e93c888a679b2c8f6"
  end
  resource "Devel::Refcount" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Devel-Refcount-0.10.tar.gz"
    sha256 "b654d46963d1a881426ba15994f28f52eb839b0d135bf239b4d1bf38b1caca4a"
  end
  resource "HTTP::Headers::Fast" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TOKUHIROM/HTTP-Headers-Fast-0.22.tar.gz"
    sha256 "cc431db68496dd884db4bc0c0b7112c1f4a4f1dc68c4f5a3caa757a1e7481b48"
  end
  resource "POSIX::strftime::Compiler" do
    url "https://cpan.metacpan.org/authors/id/K/KA/KAZEBURO/POSIX-strftime-Compiler-0.46.tar.gz"
    sha256 "bf88873248ef88cc5e68ed074493496be684ec334e11273d4654306dd9dae485"
  end
  resource "Unicode::Stringprep" do
    url "https://cpan.metacpan.org/authors/id/C/CF/CFAERBER/Unicode-Stringprep-1.105.tar.gz"
    sha256 "e6bebbc58408231fd1317db9102449b3e7da4fa437e79f637382d36313efd011"
  end
  resource "File::SearchPath" do
    url "https://cpan.metacpan.org/authors/id/T/TJ/TJENNESS/File-SearchPath-0.07.tar.gz"
    sha256 "be4a2594ef1a7577e773135add940179c6a324e07e12bcfdc463cb49119a2cb9"
  end
  resource "Authen::SASL::SASLprep" do
    url "https://cpan.metacpan.org/authors/id/C/CF/CFAERBER/Authen-SASL-SASLprep-1.100.tar.gz"
    sha256 "a4cccc34bb3f53acf0ba78c9fc61af8d156d109d1c10487ba5988a55077d1f70"
  end
  resource "Alien::Libxml2" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.19.tar.gz"
    sha256 "f4a674099bbd5747c0c3b75ead841f3b244935d9ef42ba35368024bd611174c9"
  end
  resource "PDL" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/PDL-2.099.tar.gz"
    sha256 "67cdfc04c4dab77a799f3b867ea3228e7eddb2f4419810a7c16ad66408365800"
  end
  resource "Specio" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.50.tar.gz"
    sha256 "467baf0582681626266318e3154727497d7205996fbd76674ba58ed79e10640e"
  end
  resource "Test::TCP" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/Test-TCP-2.22.tar.gz"
    sha256 "3e53c3c06d6d0980a2bfeb915602b714e682ee211ae88c11748cf2cc714e7b57"
  end
  resource "Apache::LogFormat::Compiler" do
    url "https://cpan.metacpan.org/authors/id/K/KA/KAZEBURO/Apache-LogFormat-Compiler-0.36.tar.gz"
    sha256 "94509503ee74ea820183d070c11630ee5bc0fd8c12cb74fae953ed62e4a1ac17"
  end
  resource "IPC::Run" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IPC-Run-20231003.0.tar.gz"
    sha256 "eb25bbdf5913d291797ef1bfe998f15130b455d3ed02aacde6856f0b25e4fe57"
  end
  resource "Module::Implementation" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Module-Implementation-0.09.tar.gz"
    sha256 "c15f1a12f0c2130c9efff3c2e1afe5887b08ccd033bd132186d1e7d5087fd66d"
  end
  resource "Import::Into" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Import-Into-1.002005.tar.gz"
    sha256 "bd9e77a3fb662b40b43b18d3280cd352edf9fad8d94283e518181cc1ce9f0567"
  end
  resource "Net::DNS" do
    url "https://cpan.metacpan.org/authors/id/N/NL/NLNETLABS/Net-DNS-1.49.tar.gz"
    sha256 "8da11c6d491732e6f389901b81f86d4d67a208759e7da63688b2e5a26e23be5e"
  end
  resource "File::Share" do
    url "https://cpan.metacpan.org/authors/id/I/IN/INGY/File-Share-0.27.tar.gz"
    sha256 "d6e8f4b55ebd38e0bb45e44392e3fa27dc1fde16abc5d1ff53e157e19a5755be"
  end
  resource "Dist::CheckConflicts" do
    url "https://cpan.metacpan.org/authors/id/D/DO/DOY/Dist-CheckConflicts-0.11.tar.gz"
    sha256 "ea844b9686c94d666d9d444321d764490b2cde2f985c4165b4c2c77665caedc4"
  end
  resource "HTTP::Entity::Parser" do
    url "https://cpan.metacpan.org/authors/id/K/KA/KAZEBURO/HTTP-Entity-Parser-0.25.tar.gz"
    sha256 "3a8cd0d8cba3d17cd8c04ee82d7341dfaa247dbdd94a49eb94b53f69e483ec3a"
  end
  resource "Text::Table" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Text-Table-1.135.tar.gz"
    sha256 "fca3c16e83127f7c44dde3d3f7e3c73ea50d109a1054445de8082fea794ca5d2"
  end
  resource "Module::Build::XSUtil" do
    url "https://cpan.metacpan.org/authors/id/H/HI/HIDEAKIO/Module-Build-XSUtil-0.19.tar.gz"
    sha256 "9063b3c346edeb422807ffe49ffb23038c4f900d4a77b845ce4b53d97bf29400"
  end
  resource "HTTP::Daemon" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Daemon-6.16.tar.gz"
    sha256 "b38d092725e6fa4e0c4dc2a47e157070491bafa0dbe16c78a358e806aa7e173d"
  end
  resource "Module::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Module-Install-1.21.tar.gz"
    sha256 "fbf91007f30565f3920e106055fd0d4287981d5e7dad8b35323ce4b733f15a7b"
  end
  resource "Plack" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/Plack-1.0051.tar.gz"
    sha256 "bebde91c42298ed6ec8e6c82b21433a1b49aa39412c247f3905b80f955acf77b"
  end
  resource "RPC::XML" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJRAY/RPC-XML-0.82.tar.gz"
    sha256 "5279eb0d136c533ff897f6934c3aad6f20504b997fb2606e52c5dbbd92758e73"
  end
  resource "PerlIO::via::Timeout" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAMS/PerlIO-via-Timeout-0.32.tar.gz"
    sha256 "9278f9ef668850d913d98fa4c0d7e7d667cff3503391f4a4eae73a246f2e7916"
  end
  resource "PDL::Stats" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/PDL-Stats-0.853.tar.gz"
    sha256 "05dcd804aba4aec4f4658c13253306b5a825196cdb19d48db781c0d567f13035"
  end
  resource "Class::Accessor" do
    url "https://cpan.metacpan.org/authors/id/K/KA/KASEI/Class-Accessor-0.51.tar.gz"
    sha256 "bf12a3e5de5a2c6e8a447b364f4f5a050bf74624c56e315022ae7992ff2f411c"
  end
  resource "Mouse" do
    url "https://cpan.metacpan.org/authors/id/S/SK/SKAJI/Mouse-v2.5.11.tar.gz"
    sha256 "e2a0d0930190c21a444b960793aa2e369ef28a1dd0b8f34829795f86a1915956"
  end
  resource "Redis::Fast" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHOGO/Redis-Fast-0.37.tar.gz"
    sha256 "f4565cb622f8611e4ad2afde480c35980995cb064b7ec52f934ffcc04d83d5e2"
  end
  resource "Class::Accessor::Grouped" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Class-Accessor-Grouped-0.10014.tar.gz"
    sha256 "35d5b03efc09f67f3a3155c9624126c3e162c8e3ca98ff826db358533a44c4bb"
  end
  resource "XML::LibXML" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0210.tar.gz"
    sha256 "a29bf3f00ab9c9ee04218154e0afc8f799bf23674eb99c1a9ed4de1f4059a48d"
  end
  resource "Class::Accessor::Lite" do
    url "https://cpan.metacpan.org/authors/id/K/KA/KAZUHO/Class-Accessor-Lite-0.08.tar.gz"
    sha256 "75b3b8ec8efe687677b63f0a10eef966e01f60735c56656ce75cbb44caba335a"
  end
  resource "Params::Validate" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-Validate-1.31.tar.gz"
    sha256 "1bf2518ef2c4869f91590e219f545c8ef12ed53cf313e0eb5704adf7f1b2961e"
  end
  resource "Module::Runtime::Conflicts" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Module-Runtime-Conflicts-0.003.tar.gz"
    sha256 "707cdc75038c70fe91779b888ac050f128565d3967ba96680e1b1c7cc9733875"
  end
  resource "Package::Stash" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-0.40.tar.gz"
    sha256 "5a9722c6d9cb29ee133e5f7b08a5362762a0b5633ff5170642a5b0686e95e066"
  end
  resource "B::Hooks::EndOfScope" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/B-Hooks-EndOfScope-0.28.tar.gz"
    sha256 "edac77a17fc36620c8324cc194ce1fad2f02e9fcbe72d08ad0b2c47f0c7fd8ef"
  end
  resource "Devel::OverloadInfo" do
    url "https://cpan.metacpan.org/authors/id/I/IL/ILMARI/Devel-OverloadInfo-0.007.tar.gz"
    sha256 "21a184163b90f91f06ffc7f5de0b968356546ae9b400a9d75c573c958c246222"
  end
  resource "Package::DeprecationManager" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Package-DeprecationManager-0.18.tar.gz"
    sha256 "b68d3f0ced55b7615fddbb6029b89f92a34fe0dd8c6fd6bceffc157d56834fe8"
  end
  resource "Plack::Middleware::RemoveRedundantBody" do
    url "https://cpan.metacpan.org/authors/id/S/SW/SWEETKID/Plack-Middleware-RemoveRedundantBody-0.09.tar.gz"
    sha256 "80d45f93d6b7290b0bd8b3cedd84a37fc501456cc3dec02ec7aad81c0018087e"
  end
  resource "Class::Load" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Class-Load-0.25.tar.gz"
    sha256 "2a48fa779b5297e56156380e8b32637c6c58decb4f4a7f3c7350523e11275f8f"
  end
  resource "namespace::clean" do
    url "https://cpan.metacpan.org/authors/id/R/RI/RIBASUSHI/namespace-clean-0.27.tar.gz"
    sha256 "8a10a83c3e183dc78f9e7b7aa4d09b47c11fb4e7d3a33b9a12912fd22e31af9d"
  end
  resource "IO::Socket::Timeout" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAMS/IO-Socket-Timeout-0.32.tar.gz"
    sha256 "edf915d6cc66bee43503aa6dc2b373366f38eaff701582183dad10cb8adf2972"
  end
  resource "Plack::Middleware::CrossOrigin" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Plack-Middleware-CrossOrigin-0.014.tar.gz"
    sha256 "35e80fabcc8455a6bc1aee0820fde9c4ae94baab7a795ce79932abc93004f3b7"
  end
  resource "Router::Simple" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TOKUHIROM/Router-Simple-0.17.tar.gz"
    sha256 "334615620f38eee15620ccdbf2dbd8b0a403ba1610e5b27d51737d8b0fb0c89d"
  end
  resource "Plack::Middleware::FixMissingBodyInRedirect" do
    url "https://cpan.metacpan.org/authors/id/S/SW/SWEETKID/Plack-Middleware-FixMissingBodyInRedirect-0.12.tar.gz"
    sha256 "6c22d069f5a57ac206d4659b28b8869bb9270640bb955efddd451dcc58cdb391"
  end
  resource "Twiggy" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/Twiggy-0.1026.tar.gz"
    sha256 "4d91ea6ed9ae9a8ef4314dc2a7cf52eb026b365be68386b35ea6864dfac57f9e"
  end
  resource "Getopt::Long::Descriptive" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Getopt-Long-Descriptive-0.116.tar.gz"
    sha256 "93bd88173c9b99c338085a8a70222ebb1c0ebad5c5feae1f742974a4c29c82ca"
  end
  resource "Class::Load::XS" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Class-Load-XS-0.10.tar.gz"
    sha256 "5bc22cf536ebfd2564c5bdaf42f0d8a4cee3d1930fc8b44b7d4a42038622add1"
  end
  resource "DBIx::Class" do
    url "https://cpan.metacpan.org/authors/id/R/RI/RIBASUSHI/DBIx-Class-0.082844.tar.gz"
    sha256 "e0784e3861a197ad5aa17396f18901f0aaa8bab04a4330cb50038337ec30ca7f"
  end
  resource "BSON" do
    url "https://cpan.metacpan.org/authors/id/M/MO/MONGODB/BSON-v1.12.2.tar.gz"
    sha256 "f4612c0c354310741b99ab6d26451226823150ca27109b1b391232d5cfdda6db"
  end
  resource "namespace::autoclean" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/namespace-autoclean-0.31.tar.gz"
    sha256 "d3b32c82e1d2caa9d58b8c8075965240e6cab66ab9350bd6f6bea4ca07e938d6"
  end
  resource "JSON::RPC" do
    url "https://cpan.metacpan.org/authors/id/D/DM/DMAKI/JSON-RPC-1.06.tar.gz"
    sha256 "d75ba8b558988b3fdffa12ff62a55f0f1aaff8aa73b708bff3701ff88a2b8757"
  end
  resource "CLI::Osprey" do
    url "https://cpan.metacpan.org/authors/id/A/AR/ARODLAND/CLI-Osprey-0.08.tar.gz"
    sha256 "f7480523dbdf2c2b53789c06a8bd91cf6579bb8cc5678e72ea8a1faaab30d19a"
  end
  resource "Authen::SCRAM" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Authen-SCRAM-0.011.tar.gz"
    sha256 "45108c239a7373d00941dcf0d171acd03e7c16a63ce6f7d9568ff052b17cf5a8"
  end
  resource "Redis" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAMS/Redis-2.000.tar.gz"
    sha256 "14cb899797212615b4e93f916dcbdafb48d01c5eaab2038fe6cb179bf95c6feb"
  end
  resource "Moose" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Moose-2.2207.tar.gz"
    sha256 "7c2daddc49754ded93f65b8ce9e3ac9b6d11ab27d111ec77f95a8528cf4ac409"
  end
  resource "DateTime::Locale" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.44.tar.gz"
    sha256 "12a584a4a43c46114cd41ab6981be3609588604a906463fe4f844bb88a31c2de"
  end
  resource "Log::Dispatch" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Log-Dispatch-2.71.tar.gz"
    sha256 "9d60d9648c35ce2754731eb4deb7f05809ece1bd633b74d74795aed9ec732570"
  end
  resource "MongoDB" do
    url "https://cpan.metacpan.org/authors/id/M/MO/MONGODB/MongoDB-v2.2.2.tar.gz"
    sha256 "201935f92dac94f39c35de73661e8b252439e496f228657db85ff93257c3268f"
  end
  resource "DateTime::TimeZone" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.64.tar.gz"
    sha256 "7c2d638a52e5b5ca77f325e48087495a65ba6bfbd39d858aeba98d21216964cd"
  end
  resource "Dancer2" do
    url "https://cpan.metacpan.org/authors/id/C/CR/CROMEDOME/Dancer2-1.1.2.tar.gz"
    sha256 "c1177fdc7f324430df41d9742f382069619f7a46687ebebb02c7cf98371951cf"
  end
  resource "Test::RedisServer" do
    url "https://cpan.metacpan.org/authors/id/S/SO/SONGMU/Test-RedisServer-0.23.tar.gz"
    sha256 "137ac7fb44d59fd9a2c1ebe093d9156e4d5b417bdadbbe02f8db2b480676a24f"
  end
  resource "DateTime::Format::ISO8601::Format" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PERLANCAR/DateTime-Format-ISO8601-Format-0.005.tar.gz"
    sha256 "837fe8941b4b31662a5e8ab5e19143452ffafac82161a05aa9f03bdf8c82fd69"
  end
  resource "DateTime" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-1.65.tar.gz"
    sha256 "0bfda7ff0253fb3d88cf4bdb5a14afb8cea24d147975d5bdf3c88b40e7ab140e"
  end
  resource "EV::Hiredis" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHOGO/EV-Hiredis-0.07.tar.gz"
    sha256 "2569f24defb60fde2cd9627308594ecf424a2f3d6e68139fdae11847e677c645"
  end
  resource "MooseX::Types" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/MooseX-Types-0.50.tar.gz"
    sha256 "9cd87b3492cbf0be9d2df9317b2adf9fc30663770e69906654bea3f41b17cb08"
  end
  resource "DateTime::Format::Strptime" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Format-Strptime-1.79.tar.gz"
    sha256 "701e46802c86ed4d88695c1a6dacbbe90b3390beeb794f387e7c792300037579"
  end
  resource "JSON::RPC::Common" do
    url "https://cpan.metacpan.org/authors/id/D/DM/DMCBRIDE/JSON-RPC-Common-0.11.tar.gz"
    sha256 "22062213fdae302159d012c055b7e2006eb527234088d2f216b34eec36167c62"
  end
  resource "DateTime::Format::DateParse" do
    url "https://cpan.metacpan.org/authors/id/J/JH/JHOBLITT/DateTime-Format-DateParse-0.05.tar.gz"
    sha256 "f6eca4c8be66ce9992ee150932f8fcf07809fd3d1664caf200b8a5fd3a7e5ebc"
  end
  resource "DateTime::Format::Builder" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Format-Builder-0.83.tar.gz"
    sha256 "61ffb23d85b3ca1786b2da3289e99b57e0625fe0e49db02a6dc0cb62c689e2f2"
  end
  resource "RPC::Any" do
    url "https://cpan.metacpan.org/authors/id/M/MK/MKANAT/RPC-Any-1.00.tar.gz"
    sha256 "abd87df3bc9bc0f7e9113079f94fe655c16600957f32c2d6a2d50c697563eb69"
  end
  resource "DateTime::Format::MySQL" do
    url "https://cpan.metacpan.org/authors/id/X/XM/XMIKEW/DateTime-Format-MySQL-0.08.tar.gz"
    sha256 "19cb70e98584655e354d2d6a8e71cc5ca902dddc3ac44416712f9163d122b9e8"
  end
  resource "DateTime::Format::ISO8601" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Format-ISO8601-0.16.tar.gz"
    sha256 "582847f6e029065334a00564f20cd7c28f4e5cd4ec21513d0f692531ed3b56e1"
  end

  def install
    ENV["PERL_CANARY_STABILITY_NOPROMPT"] = "1"
    ENV["PERL_MM_USE_DEFAULT"] = "1"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_create_path "PATH", libexec/"bin"
    resources.each do |r|
      r.stage do
        if File.exist?("Makefile.PL")
          if r.name == "Template::Toolkit"
            system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "NO_MYMETA=1", "TT_XS_DEFAULT=y", "TT_ACCEPT=y"
          else
            system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "NO_MYMETA=1"
          end
          system "make"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system "./Build"
          system "./Build", "install"
        end
      end
    end

    Dir.chdir("dev_container") do
      ENV["KB_IGNORE_MISSING_DEPENDENCIES"] = "1"
      ENV["PERL5LIB_ADDITIONS"] = libexec/"lib/perl5"
      ENV["DEPLOY_RUNTIME"] = ENV["HOMEBREW_DEFAULT_PREFIX"]
      system("./bootstrap", ENV["DEPLOY_RUNTIME"])
      system("bash", "-c",
      ". user-env.sh; export \"PERL5LIB=$PERL5LIB:#{libexec}/lib/perl5\"; echo $PERL5LIB;make -j 1")
      system("bash", "-c",
      ". user-env.sh; export \"PERL5LIB=$PERL5LIB:#{libexec}/lib/perl5\"; " \
      "perl auto-deploy --runtime #{ENV["DEPLOY_RUNTIME"]} --target #{prefix} deploy.cfg")
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test BV-BRC-CLI`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "#{bin}/p3-echo", "foobar"
    system "#{bin}/p3-echo 83332.12 | #{bin}/p3-get-genome-data"
  end
end
