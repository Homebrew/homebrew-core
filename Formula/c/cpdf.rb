class Cpdf < Formula
  desc "PDF Command-line Tools"
  homepage "https://github.com/johnwhitington/cpdf-source"
  url "https://github.com/johnwhitington/cpdf-source/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "8f96f92b2b19b42a6ee3aeb5986e7223a9fcfc8c65e534b6b45cb9525251ca80"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "37bcc7e29c86c7fdc51113f4ab25638d86ac204174774d2f56800b488919803a"
    sha256 cellar: :any, arm64_sequoia: "202ca43f03553ff792742a73d31dbbbca50a4be00e23b69caa2c29a2c3472e9c"
    sha256 cellar: :any, arm64_sonoma:  "ed1f564702633df6e4fd5bcfdc012dd2e5dea2882c554193d31d5646d9fc4e66"
    sha256 cellar: :any, sonoma:        "c1f5c5901b4676c3fd881900309d4c56bce3122861ca5a154fdf6da61c3199e5"
    sha256 cellar: :any, arm64_linux:   "62f68c4c883ffab8b7f916eb325d4226cc6d013de16aefa53b21adad9d677310"
    sha256 cellar: :any, x86_64_linux:  "b9a7a19d6a2c06a43c303fcc26c2a623a62c770e53379af0959ec2a07a0b93a6"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlpdf"
  depends_on "ocaml"

  def install
    # For OCamlmakefile
    ENV.deparallelize

    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = formula_opt_libexec("ocaml-findlib")/"findlib.conf"
    end

    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    (lib/"ocaml").mkpath
    cp formula_opt_lib("ocaml")/"ocaml/Makefile.config", lib/"ocaml"

    # install in #{lib}/ocaml not #{HOMEBREW_PREFIX}/lib/ocaml
    inreplace lib/"ocaml/Makefile.config" do |s|
      s.change_make_var! "prefix", prefix
    end

    system "make"
    (lib/"ocaml/stublibs").mkpath # `make install` assumes this directory exists
    system "make", "install", "STDLIBDIR=#{lib}/ocaml"

    rm lib/"ocaml/Makefile.config" # avoid conflict with ocaml

    bin.install "cpdf"
  end

  test do
    system bin/"cpdf", "-create-pdf", "-o", "out.pdf"
    assert_match version.to_s, shell_output(bin/"cpdf")
    assert_path_exists testpath/"out.pdf"
  end
end
