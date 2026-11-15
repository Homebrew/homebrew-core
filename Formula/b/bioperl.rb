class Bioperl < Formula
  desc "Perl tools for bioinformatics, genomics and life science"
  homepage "https://bioperl.org"
  url "https://cpan.metacpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-1.7.8.tar.gz"
  sha256 "c490a3be7715ea6e4305efd9710e5edab82dabc55fd786b6505b550a30d71738"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 7
  compatibility_version 1
  head "https://github.com/bioperl/bioperl-live.git", branch: "master"

  # We specifically match versions with three numeric parts because upstream
  # documentation mentions that release versions have three parts and there are
  # older tarballs with fewer than three parts that we need to omit for version
  # comparison to work correctly.
  livecheck do
    url :stable
    regex(/href=["']?BioPerl[._-]v?(\d+\.\d+\.\d+)(?:\.?_\d+)?\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19b723e4c20210e3e27250dafc3aa659fe3a224387fa5bce48e8a8a9b5cfa4f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d83d9db3a6fed7f4d5a04efe1d52af7f1f5801faf34c26721bfb4a0c38ff7d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "655e18a7ba7f2f704cc49a3f0cfd66f570287f7927e1b907b3ffaa5fc4dd4c0d"
    sha256 cellar: :any,                 arm64_linux:       "6c9c53a258059f7cfe6e7b670dcf93f01f2251ae28bab7c26aae76af4ed5d161"
    sha256 cellar: :any,                 x86_64_linux:      "e54dabcfbbc73f209b186b20c934ca630c0746e8919972f0f0f78a5231b61625"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "perl"

  on_linux do
    depends_on "berkeley-db@5"

    resource "Module::Build" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
      sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
    end

    resource "Capture::Tiny" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.50.tar.gz"
      sha256 "ca6e8d7ce7471c2be54e1009f64c367d7ee233a2894cacf52ebe6f53b04e81e5"
    end

    resource "File::chdir" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1011.tar.gz"
      sha256 "31ebf912df48d5d681def74b9880d78b1f3aca4351a0ed1fe3570b8e03af6c79"
    end

    resource "File::Which" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
      sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
    end

    resource "Path::Tiny" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.150.tar.gz"
      sha256 "ff20713d1a14d257af9c78209001f40dc177e4b9d1496115cbd8726d577946c7"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.40.tar.gz"
      sha256 "ef5d2ef099a1a24a6e83ffe543de73337805d3d39c00b84fa205d725ad1a1b63"
    end

    resource "Alien::Base::Wrapper" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-2.88.tar.gz"
      sha256 "c14346bace2b50cae62f1ee70a907f4c7383fabf90b034272ee52a5b1345fbba"
    end

    resource "Alien::Build::Plugin::Download::GitLab" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-Plugin-Download-GitLab-0.01.tar.gz"
      sha256 "c1f089c8ea152a789909d48a83dbfcf2626f773daf30431c8622582b26aba902"
    end

    resource "Alien::Libxml2" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.20.tar.gz"
      sha256 "56aae7b339bbeb02f77c5801f57a821be5791b51f43bf7f9062bb3bfa444c328"
    end

    resource "Algorithm::Diff" do
      url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Algorithm-Diff-1.201.tar.gz"
      sha256 "0022da5982645d9ef0207f3eb9ef63e70e9713ed2340ed7b3850779b0d842a7d"
    end

    resource "Class::Data::Inheritable" do
      url "https://cpan.metacpan.org/authors/id/R/RS/RSHERER/Class-Data-Inheritable-0.10.tar.gz"
      sha256 "aa1ae68a611357b7bfd9a2f64907cc196ddd6d047cae64ef9d0ad099d98ae54a"
    end

    resource "Class::Inspector" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Class-Inspector-1.36.tar.gz"
      sha256 "cc295d23a472687c24489d58226ead23b9fdc2588e522f0b5f0747741700694e"
    end

    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.51.tar.gz"
      sha256 "f17f66fec97dacca67ac9585701d2d079cfc80539fe6e8160c201c4e55f67507"
    end

    resource "DB_File" do
      url "https://cpan.metacpan.org/authors/id/P/PM/PMQS/DB_File-1.861.tar.gz"
      sha256 "608bc6ff234ae08ac5bf6b85887882965aaa89554cf09d09fb926fd4e389094f"
    end

    resource "Devel::StackTrace" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.05.tar.gz"
      sha256 "63cb6196e986a7e578c4d28b3c780e7194835bfc78b68eeb8f00599d4444888c"
    end

    resource "Encode::Locale" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end

    resource "Error" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Error-0.17030.tar.gz"
      sha256 "34d382276c0fb0d6b38355b94c96a30b12d834d5662eb53f088ee25e3e712924"
    end

    resource "Exception::Class" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Exception-Class-1.46.tar.gz"
      sha256 "e2f8c0708ff8de8b1bb7be1faa3cdb240fdd9774bc741627350577ea7e0e76a1"
    end

    resource "Exporter::Tiny" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.006003.tar.gz"
      sha256 "6499f09a6432cf87b133fb9580a8a9a9a6c566821346b1fdee95f7b64c0317b1"
    end

    resource "FFI::CheckLib" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/FFI-CheckLib-0.31.tar.gz"
      sha256 "04d885fc377d44896e5ea1c4ec310f979bb04f2f18658a7e7a4d509f7e80bb80"
    end

    resource "File::Listing" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.16.tar.gz"
      sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
    end

    resource "File::ShareDir::Install" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.14.tar.gz"
      sha256 "8f9533b198f2d4a9a5288cbc7d224f7679ad05a7a8573745599789428bc5aea0"
    end

    resource "File::ShareDir" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-ShareDir-1.118.tar.gz"
      sha256 "3bb2a20ba35df958dc0a4f2306fc05d903d8b8c4de3c8beefce17739d281c958"
    end

    resource "HTML::HeadParser" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.86.tar.gz"
      sha256 "5305e1d5faa70ee0aa282d85a5c9aa93911e8c7afa590ad1ced5703a544e20f6"
    end

    resource "HTML::Tagset" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz"
      sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
    end

    resource "HTTP::Cookies" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.12.tar.gz"
      sha256 "4e460c4bae76285bfc726f641349402fc9038fcd9ca0f33346bec036d73876b8"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.08.tar.gz"
      sha256 "b57d80ca6d821c6949ca48b27467d45aba7a9c77346562306facca781a003e44"
    end

    resource "HTTP::Negotiate" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
      sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
    end

    resource "HTTP::Response" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-7.04.tar.gz"
      sha256 "699f3350dbb7bd8fdc9f3b013b0c91b7c059783708443e39bc395fa33352f006"
    end

    resource "IO::HTML" do
      url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
      sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
    end

    resource "IO::Scalar" do
      url "https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/IO-Stringy-2.113.tar.gz"
      sha256 "51220fcaf9f66a639b69d251d7b0757bf4202f4f9debd45bdd341a6aca62fe4e"
    end

    resource "IO::String" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz"
      sha256 "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0"
    end

    resource "List::MoreUtils" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz"
      sha256 "63b1f7842cd42d9b538d1e34e0330de5ff1559e4c2737342506418276f646527"
    end

    resource "List::MoreUtils::XS" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz"
      sha256 "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242"
    end

    resource "LWP::MediaTypes" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.05.tar.gz"
      sha256 "abb2dcfbf069317fe65b098e3b2ad58c5eb33e9a839b9190cce6d371f8966cc1"
    end

    resource "LWP::UserAgent" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.83.tar.gz"
      sha256 "e75f0fa9d3c6f0daf5a5a72fa9f8b1c9c0d23e3a84a8522ccb4f835232b95505"
    end

    resource "MIME::Base32" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/MIME-Base32-1.303.tar.gz"
      sha256 "ab21fa99130e33a0aff6cdb596f647e5e565d207d634ba2ef06bdbef50424e99"
    end

    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.24.tar.gz"
      sha256 "290ed9a97b05c7935b048e6d2a356035871fca98ad72c01c5961726adf85c83c"
    end

    resource "Sub::Uplevel" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Sub-Uplevel-0.2800.tar.gz"
      sha256 "b4f3f63b80f680a421332d8851ddbe5a8e72fcaa74d5d1d98f3c8cc4a3ece293"
    end

    resource "Test::Deep" do
      url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Test-Deep-1.205.tar.gz"
      sha256 "42781e9943a7a215e662c4973b9feafdc019fd16469bdb849a8537ee58956273"
    end

    resource "Test::Differences" do
      url "https://cpan.metacpan.org/authors/id/D/DC/DCANTRELL/Test-Differences-0.73.tar.gz"
      sha256 "3c113f4e25c38323a3fe5992d30c337264d00ef872aecfd2d9431ca8ea0083e2"
    end

    resource "Test::Exception" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Exception-0.43.tar.gz"
      sha256 "156b13f07764f766d8b45a43728f2439af81a3512625438deab783b7883eb533"
    end

    resource "Test::Most" do
      url "https://cpan.metacpan.org/authors/id/D/DC/DCANTRELL/Test-Most-0.42.tar.gz"
      sha256 "a418935483def0a46259a50bff6320842792a5a02777192667de222475253075"
    end

    resource "Test::RequiresInternet" do
      url "https://cpan.metacpan.org/authors/id/M/MA/MALLEN/Test-RequiresInternet-0.05.tar.gz"
      sha256 "bba7b32a1cc0d58ce2ec20b200a7347c69631641e8cae8ff4567ad24ef1e833e"
    end

    resource "Test::Warn" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BIGJ/Test-Warn-0.37.tar.gz"
      sha256 "98ca32e7f2f5ea89b8bfb9a0609977f3d153e242e2e51705126cb954f1a06b57"
    end

    resource "Text::Diff" do
      url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Text-Diff-1.46.tar.gz"
      sha256 "3fc983e3140fa2580250bbcf2b52e2acbdbc5abda4374c3be78235905d8ca8eb"
    end

    resource "Time::Zone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.35.tar.gz"
      sha256 "baddd0306ae2e86e9ec28d3de5439e514643e80b3735e43bd0fbb426d73304de"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.32.tar.gz"
      sha256 "ef2d6cab0bad18e3ab1c4e6125cc5f695c7e459899f512451c8fa3ef83fa7fc0"
    end

    resource "WWW::RobotRules" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/WWW-RobotRules-6.03.tar.gz"
      sha256 "8522b532935a11bfa688c2e113bac66729df4851be50c2c26d4b06f45fade472"
    end

    resource "XML::NamespaceSupport" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz"
      sha256 "47e995859f8dd0413aa3f22d350c4a62da652e854267aa0586ae544ae2bae5ef"
    end

    resource "XML::SAX::Base" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz"
      sha256 "66cb355ba4ef47c10ca738bd35999723644386ac853abbeb5132841f5e8a2ad0"
    end

    resource "XML::SAX::DocumentLocator" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-1.02.tar.gz"
      sha256 "4506c387043aa6a77b455f00f57409f3720aa7e553495ab2535263b4ed1ea12a"
    end

    resource "XML::LibXML" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-LibXML-2.0213.tar.gz"
      sha256 "2af21c5d61ac34ea26a5fabf15ba5a5841e648f7189db3e33b6f28b5489802ab"
    end

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.59.tar.gz"
      sha256 "a358fd7c49f5e27717a644a9102bd21dc7fc25a415983279c59b1580e2b62a58"
    end

    resource "XML::Writer" do
      url "https://cpan.metacpan.org/authors/id/J/JO/JOSEPHW/XML-Writer-0.900.tar.gz"
      sha256 "73c8f5bd3ecf2b350f4adae6d6676d52e08ecc2d7df4a9f089fa68360d400d1f"
    end

    resource "YAML" do
      url "https://cpan.metacpan.org/authors/id/T/TI/TINITA/YAML-1.321.tar.gz"
      sha256 "d461167b8b4aa9244f736a7a740830141e61dddee301e456bf642e81d3cea193"
    end
  end

  resource "XML::DOM" do
    url "https://cpan.metacpan.org/authors/id/T/TJ/TJMATHER/XML-DOM-1.46.tar.gz"
    sha256 "8ba24b0b459b01d6c5e5b0408829c7d5dfe47ff79b3548c813759048099b175e"
  end

  resource "XML::RegExp" do
    url "https://cpan.metacpan.org/authors/id/T/TJ/TJMATHER/XML-RegExp-0.04.tar.gz"
    sha256 "df1990096036085c8e2d45904fe180f82bfed40f1a7e05243f334ea10090fc54"
  end

  resource "XML::Parser::PerlSAX" do
    url "https://cpan.metacpan.org/authors/id/K/KM/KMACLEOD/libxml-perl-0.08.tar.gz"
    sha256 "4571059b7b5d48b7ce52b01389e95d798bf5cf2020523c153ff27b498153c9cb"
  end

  resource "IPC::Run" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IPC-Run-20260402.0.tar.gz"
    sha256 "d6a326a8b1ffb19495dea4ff5a09ef138bf3562ab1b069d3fb7efbc77b9f6aca"
  end

  resource "XML::Twig" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MIROD/XML-Twig-3.55.tar.gz"
    sha256 "69326e5edc05c759ccc78fbe05ca63759a035fe7a5337b8ddba6c3dd42f64f6c"
  end

  resource "Data::Stag" do
    url "https://cpan.metacpan.org/authors/id/C/CM/CMUNGALL/Data-Stag-0.14.tar.gz"
    sha256 "4ab122508d2fb86d171a15f4006e5cf896d5facfa65219c0b243a89906258e59"
  end

  resource "Graph::Directed" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/Graph-0.9735.tar.gz"
    sha256 "5c9a51f89efe7a36db288590bf66753f2417afd41b82363e39f2f3101d498065"
  end

  resource "Heap" do
    url "https://cpan.metacpan.org/authors/id/J/JM/JMM/Heap-0.80.tar.gz"
    sha256 "ccda29f3c93176ad0fdfff4dd6f5e4ac90b370cba4b028386b7343bf64139bde"
  end

  resource "Set::Object" do
    url "https://cpan.metacpan.org/authors/id/R/RU/RURBAN/Set-Object-1.43.tar.gz"
    sha256 "e3b3c7c7ecb91ef6d20eb06bf6bff74e41c40b75bd234e107d2ecf78d3dea9d1"
  end

  resource "XML::SAX::Writer" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-SAX-Writer-0.57.tar.gz"
    sha256 "3d61d07ef43b0126f5b4de4f415a256fa859fa88dc4fdabaad70b7be7c682cf0"
  end

  resource "XML::Filter::BufferText" do
    url "https://cpan.metacpan.org/authors/id/R/RB/RBERJON/XML-Filter-BufferText-1.01.tar.gz"
    sha256 "8fd2126d3beec554df852919f4739e689202cbba6a17506e9b66ea165841a75c"
  end

  resource "Set::Scalar" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAVIDO/Set-Scalar-1.29.tar.gz"
    sha256 "a3dc1526f3dde72d3c64ea00007b86ce608cdcd93567cf6e6e42dc10fdc4511d"
  end

  deny_network_access!

  def install
    ENV["ALIEN_INSTALL_TYPE"] = "system"
    ENV["PERL_MM_USE_DEFAULT"] = "1"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "INSTALLSITESCRIPT=#{bin}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"
    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    sequence = ">homebrew\ncattaaatggaataacgcgaatgg"
    (testpath/"test.fa").write sequence
    assert_match ">homebrew\nH*ME*REW", pipe_output(bin/"bp_translate_seq", sequence, 0)
    assert_match(/>homebrew-100_percent-1\n[atg]/, shell_output("#{bin}/bp_mutate -i test.fa -p 100 -n 1"))
    assert_match "GC content is 0.3750", shell_output("#{bin}/bp_gccalc test.fa")
  end
end
