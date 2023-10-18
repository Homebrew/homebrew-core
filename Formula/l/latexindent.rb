class Latexindent < Formula
  desc "Add indentation to LaTeX files"
  homepage "https://latexindentpl.readthedocs.io"
  url "https://github.com/cmhughes/latexindent.pl/archive/V3.23.3.tar.gz"
  sha256 "db12419a48758400a8f856e09b3b657b825b0359abc31a610c46926ab4b27e84"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8fae1b5754ddac8f14fa5c08af513e5e2e58d7fa25ed8387e6d6fe66509d03a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "679c941859d53509ed93a15fb9c0cea4f2b656a3f10f03cd7c4955fd8be3d9b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "627a5e20a868da546f9830a9b304dfc1687ce2a6b6b502e200718f1adb0aadc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b24aba571bfaca80b7872e3856b08bd658259f7d5a554892a0da2e76cbe3f55a"
    sha256 cellar: :any_skip_relocation, ventura:        "0e2420adb57dd602a201cf919785713658c6ea502d4774e81d2c3de4070e65cd"
    sha256 cellar: :any_skip_relocation, monterey:       "71b3ce724a7683b3a65a4ed1690c37d4b4052db05f53b62ef03a935cc1fb7102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a85cfdf12575ea368a6832843bb3da40757d56fb6e61c640aa136c42a1d7acc"
  end

  depends_on "perl"

  resource "Mac::SystemDirectory" do
    on_macos do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Mac-SystemDirectory-0.14.tar.gz"
      sha256 "b3c336fe20850042d30e1db1e8d191d3c056cc1072a472eb4e5bd7229056dee1"
    end
  end

  resource "B::Hooks::EndOfScope" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/B-Hooks-EndOfScope-0.26.tar.gz"
    sha256 "39df2f8c007a754672075f95b90797baebe97ada6d944b197a6352709cb30671"
  end

  resource "Class::Data::Inheritable" do
    url "https://cpan.metacpan.org/authors/id/R/RS/RSHERER/Class-Data-Inheritable-0.09.tar.gz"
    sha256 "44088d6e90712e187b8a5b050ca5b1c70efe2baa32ae123e9bd8f59f29f06e4d"
  end

  resource "Devel::GlobalDestruction" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Devel-GlobalDestruction-0.14.tar.gz"
    sha256 "34b8a5f29991311468fe6913cadaba75fd5d2b0b3ee3bb41fe5b53efab9154ab"
  end

  resource "Devel::StackTrace" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Devel-StackTrace-2.04.tar.gz"
    sha256 "cd3c03ed547d3d42c61fa5814c98296139392e7971c092e09a431f2c9f5d6855"
  end

  resource "Dist::CheckConflicts" do
    url "https://cpan.metacpan.org/authors/id/D/DO/DOY/Dist-CheckConflicts-0.11.tar.gz"
    sha256 "ea844b9686c94d666d9d444321d764490b2cde2f985c4165b4c2c77665caedc4"
  end

  resource "Eval::Closure" do
    url "https://cpan.metacpan.org/authors/id/D/DO/DOY/Eval-Closure-0.14.tar.gz"
    sha256 "ea0944f2f5ec98d895bef6d503e6e4a376fea6383a6bc64c7670d46ff2218cad"
  end

  resource "Exception::Class" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Exception-Class-1.45.tar.gz"
    sha256 "5482a77ef027ca1f9f39e1f48c558356e954936fc8fbbdee6c811c512701b249"
  end

  resource "File::HomeDir" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-HomeDir-1.006.tar.gz"
    sha256 "593737c62df0f6dab5d4122e0b4476417945bb6262c33eedc009665ef1548852"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end

  resource "Log::Dispatch" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Log-Dispatch-2.71.tar.gz"
    sha256 "9d60d9648c35ce2754731eb4deb7f05809ece1bd633b74d74795aed9ec732570"
  end

  resource "Log::Log4perl" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/Log-Log4perl-1.57.tar.gz"
    sha256 "0f8fcb7638a8f3db4c797df94fdbc56013749142f2f94cbc95b43c9fca096a13"
  end

  resource "MIME::Charset" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/MIME-Charset-1.013.1.tar.gz"
    sha256 "1bb7a6e0c0d251f23d6e60bf84c9adefc5b74eec58475bfee4d39107e60870f0"
  end

  resource "MRO::Compat" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/MRO-Compat-0.15.tar.gz"
    sha256 "0d4535f88e43babd84ab604866215fc4d04398bd4db7b21852d4a31b1c15ef61"
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
    sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
  end

  resource "Module::Implementation" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Module-Implementation-0.09.tar.gz"
    sha256 "c15f1a12f0c2130c9efff3c2e1afe5887b08ccd033bd132186d1e7d5087fd66d"
  end

  resource "Module::Runtime" do
    url "https://cpan.metacpan.org/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz"
    sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
  end

  resource "Package::Stash" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-0.40.tar.gz"
    sha256 "5a9722c6d9cb29ee133e5f7b08a5362762a0b5633ff5170642a5b0686e95e066"
  end

  resource "Package::Stash::XS" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-XS-0.30.tar.gz"
    sha256 "26bad65c1959c57379b3e139dc776fbec5f702906617ef27cdc293ddf1239231"
  end

  resource "Params::ValidationCompiler" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.31.tar.gz"
    sha256 "7b6497173f1b6adb29f5d51d8cf9ec36d2f1219412b4b2410e9d77a901e84a6d"
  end

  resource "Role::Tiny" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.002004.tar.gz"
    sha256 "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45"
  end

  resource "Specio" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.48.tar.gz"
    sha256 "0c85793580f1274ef08173079131d101f77b22accea7afa8255202f0811682b2"
  end

  resource "Sub::Exporter::Progressive" do
    url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
    sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
  end

  resource "Sub::Identify" do
    url "https://cpan.metacpan.org/authors/id/R/RG/RGARCIA/Sub-Identify-0.14.tar.gz"
    sha256 "068d272086514dd1e842b6a40b1bedbafee63900e5b08890ef6700039defad6f"
  end

  resource "Sub::Quote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006008.tar.gz"
    sha256 "94bebd500af55762e83ea2f2bc594d87af828072370c7110c60c238a800d15b2"
  end

  resource "Test::Fatal" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Test-Fatal-0.017.tar.gz"
    sha256 "37dfffdafb84b762efe96b02fb2aa41f37026c73e6b83590db76229697f3c4a6"
  end

  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
    sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
  end

  resource "Unicode::LineBreak" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end

  resource "Variable::Magic" do
    url "https://cpan.metacpan.org/authors/id/V/VP/VPIT/Variable-Magic-0.63.tar.gz"
    sha256 "ba4083b2c31ff2694f2371333d554c826aaf24b4d98d03e48b5b4a43a2a0e679"
  end

  resource "XString" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/XString-0.005.tar.gz"
    sha256 "f247f55c19aee6ba4a1ae73c0804259452e02ea85a9be07f8acf700a5138f884"
  end

  resource "YAML::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.74.tar.gz"
    sha256 "7b38ca9f5d3ce24230a6b8bdc1f47f5b2db348e7f7f9666c26f5955636e33d6c"
  end

  resource "namespace::autoclean" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/namespace-autoclean-0.29.tar.gz"
    sha256 "45ebd8e64a54a86f88d8e01ae55212967c8aa8fed57e814085def7608ac65804"
  end

  resource "namespace::clean" do
    url "https://cpan.metacpan.org/authors/id/R/RI/RIBASUSHI/namespace-clean-0.27.tar.gz"
    sha256 "8a10a83c3e183dc78f9e7b7aa4d09b47c11fb4e7d3a33b9a12912fd22e31af9d"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        args = ["INSTALL_BASE=#{libexec}"]
        args.unshift "--defaultdeps" if r.name == "MIME::Charset"
        system "perl", "Makefile.PL", *args
        system "make", "install"
      end
    end

    (libexec/"lib/perl5").install "LatexIndent"
    (libexec/"bin").install "latexindent.pl"
    (libexec/"bin").install "defaultSettings.yaml"
    (bin/"latexindent").write_env_script(libexec/"bin/latexindent.pl", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\title{latexindent Homebrew Test}
      \\begin{document}
      \\maketitle
      \\begin{itemize}
      \\item Hello
      \\item World
      \\end{itemize}
      \\end{document}
    EOS
    assert_match <<~EOS, shell_output("#{bin}/latexindent #{testpath}/test.tex")
      \\documentclass{article}
      \\title{latexindent Homebrew Test}
      \\begin{document}
      \\maketitle
      \\begin{itemize}
      	\\item Hello
      	\\item World
      \\end{itemize}
      \\end{document}
    EOS
  end
end
