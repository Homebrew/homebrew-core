class Latexindent < Formula
  desc "Add indentation to LaTeX files"
  homepage "https://ctan.org/pkg/latexindent"
  url "https://github.com/cmhughes/latexindent.pl/archive/V3.13.2.tar.gz"
  sha256 "d63e5dc6c03261bd6abea9f3190e6be09d67683f5ad87247924690b63644a60d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc46874ab98e70137cf384e22eb2e757faa4181a0c193a22240057f54ce3fe4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "851728562b136498fd4f448f91cd24154db4655e8092eae307862c2b86cf35cc"
    sha256 cellar: :any_skip_relocation, monterey:       "109f8996af049e86310e14798faf2b856715e5ea7c0e44e54f14795643957a9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a51938bc0e9d194e230146310e59f1a1296a8994bd24914b8daa56a7a5ead580"
    sha256 cellar: :any_skip_relocation, catalina:       "ef39f8d1407a6d59e62a79ba14d66fc9dac9a459fe3b423124f1b5eb0e36343f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf8a3db69d29f03507855a6f44c5b02dca8dbe977f8e0124e113590b0ed36a7f"
  end

  depends_on "perl"

  on_macos do
    resource "Mac::SystemDirectory" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Mac-SystemDirectory-0.13.tar.gz"
      sha256 "8730740e4ff3ea4812139b0787dbd1b544e093a08218d908071629b70fde3684"
    end
  end

  resource "B::Hooks::EndOfScope" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/B-Hooks-EndOfScope-0.25.tar.gz"
    sha256 "da1b6a9f7c7424776363182f9673e666b06136f13dc744241f7adce3d1ad0c1a"
  end

  resource "Class::Data::Inheritable" do
    url "https://cpan.metacpan.org/authors/id/T/TM/TMTM/Class-Data-Inheritable-0.08.tar.gz"
    sha256 "9967feceea15227e442ec818723163eb6d73b8947e31f16ab806f6e2391af14a"
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
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Log-Dispatch-2.70.tar.gz"
    sha256 "a3d91cc52467d3a3c6683103f3df4472d71e405a45f553289448713ac4293f21"
  end

  resource "Log::Log4perl" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETJ/Log-Log4perl-1.54.tar.gz"
    sha256 "bbabe42d3b4cdaa3a47666b957be81d55bbd1cbcffcdff2b119586d33602eabe"
  end

  resource "MIME::Charset" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/MIME-Charset-1.012.2.tar.gz"
    sha256 "878c779c0256c591666bd06c0cde4c0d7820eeeb98fd1183082aee9a1e7b1d13"
  end

  resource "MRO::Compat" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/MRO-Compat-0.14_01.tar.gz"
    sha256 "bc214d7964bc72f5a4015cc6b0d27376071cb64bd955280fea40c046b64d911a"
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz"
    sha256 "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717"
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
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-0.39.tar.gz"
    sha256 "9165f555112e080493ce0e9129de0886da30b2593fb353a2abd1c76b2d2621b5"
  end

  resource "Package::Stash::XS" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Package-Stash-XS-0.29.tar.gz"
    sha256 "d3676ba94641e03d6a30e951f09266c4c3ca3f5b58aa7b314a67f28e419878aa"
  end

  resource "Params::ValidationCompiler" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.30.tar.gz"
    sha256 "dc5bee23383be42765073db284bed9fbd819d4705ad649c20b644452090d16cb"
  end

  resource "Role::Tiny" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.002004.tar.gz"
    sha256 "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45"
  end

  resource "Specio" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.47.tar.gz"
    sha256 "f41307f14444f8777e572f27eeb6a964084399e7e382c47c577827ad8a286a1c"
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
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006006.tar.gz"
    sha256 "6e4e2af42388fa6d2609e0e82417de7cc6be47223f576592c656c73c7524d89d"
  end

  resource "Test::Fatal" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Test-Fatal-0.016.tar.gz"
    sha256 "7283d430f2ba2030b8cd979ae3039d3f1b2ec3dde1a11ca6ae09f992a66f788f"
  end

  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.30.tar.gz"
    sha256 "da5bd0d5c903519bbf10bb9ba0cb7bcac0563882bcfe4503aee3fb143eddef6b"
  end

  resource "Unicode::LineBreak" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end

  resource "Variable::Magic" do
    url "https://cpan.metacpan.org/authors/id/V/VP/VPIT/Variable-Magic-0.62.tar.gz"
    sha256 "3f9a18517e33f006a9c2fc4f43f01b54abfe6ff2eae7322424f31069296b615c"
  end

  resource "XString" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/XString-0.005.tar.gz"
    sha256 "f247f55c19aee6ba4a1ae73c0804259452e02ea85a9be07f8acf700a5138f884"
  end

  resource "YAML::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.73.tar.gz"
    sha256 "bc315fa12e8f1e3ee5e2f430d90b708a5dc7e47c867dba8dce3a6b8fbe257744"
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
    (bin/"latexindent").write_env_script("#{libexec}/bin/latexindent.pl", PERL5LIB: ENV["PERL5LIB"])
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
