class Pyre < Formula
  include Language::Python::Virtualenv

  desc "Performant type-checking for python"
  homepage "https://pyre-check.org"
  url "https://files.pythonhosted.org/packages/fd/94/bbbb7b51310bc17fd80453f17c72fdf5079dbfe97558c511295be50a4880/pyre-check-0.9.22.tar.gz"
  sha256 "e082f926dff71661959535c3936fca5ad40a44858b5fd3e99009a616a1b57083"
  license "MIT"
  head "https://github.com/facebook/pyre-check.git", branch: "main"

  depends_on "dune" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "python@3.13"
  depends_on "watchman"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "dataclasses-json" do
    url "https://files.pythonhosted.org/packages/85/94/1b30216f84c48b9e0646833f6f2dd75f1169cc04dc45c48fe39e644c89d5/dataclasses-json-0.5.7.tar.gz"
    sha256 "c2c11bc8214fbf709ffc369d11446ff6945254a7f09128154a7620613d8fda90"
  end

  resource "intervaltree" do
    url "https://files.pythonhosted.org/packages/50/fb/396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bb/intervaltree-3.1.0.tar.gz"
    sha256 "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d"
  end

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/4d/c4/5577b92173199299e0d32404aa92a156d353d6ec0f74148f6e418e0defef/libcst-1.5.0.tar.gz"
    sha256 "8478abf21ae3861a073e898d80b822bd56e578886331b33129ba77fec05b8c24"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/b7/41/05580fed5798ba8032341e7e330b866adc88dfca3bc3ec86c04e4ffdc427/marshmallow-3.23.0.tar.gz"
    sha256 "98d8827a9f10c03d44ead298d2e99c6aea8197df18ccfad360dae7f89a50da2e"
  end

  resource "marshmallow-enum" do
    url "https://files.pythonhosted.org/packages/8e/8c/ceecdce57dfd37913143087fffd15f38562a94f0d22823e3c66eac0dca31/marshmallow-enum-1.5.1.tar.gz"
    sha256 "38e697e11f45a8e64b4a1e664000897c659b60aa57bfa18d44e226a9920b6e58"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/26/10/2a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310/psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyre-extensions" do
    url "https://files.pythonhosted.org/packages/d5/7f/dfbabb6b4b23aacc0efa6ef51dc9c6f63532a02323bddcf1475dd0993854/pyre_extensions-0.0.31.tar.gz"
    sha256 "945806dd33027856cf6e41c9c4adacffab2b56993f8762ff4ea7826f95db0481"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "testslide" do
    url "https://files.pythonhosted.org/packages/ee/6f/c8d6d60a597c693559dab3b3362bd01e2212530e9a163eb0164af81e1ec1/TestSlide-2.7.1.tar.gz"
    sha256 "d25890d5c383f673fac44a5f9e2561b7118d04f29f2c2b3d4f549e6db94cb34d"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/3a/38/c61bfcf62a7b572b5e9363a802ff92559cb427ee963048e1442e3aef7490/typeguard-2.13.3.tar.gz"
    sha256 "00edaa8da3a133674796cf5ea87d9f4b4c367d77476e185e80251cc13dfbb8c4"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/dc/74/1789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264a/typing_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  def install
    ENV["OPAMROOT"] = buildpath/"opamroot"
    system "opam", "init", "--disable-sandboxing", "--bare", "-y"
    system "opam", "switch", "create", "ocaml-system", "-y"
    system "opam", "install", "dune", "-y"
    system "opam", "install", ".", "--deps-only", "-y"
    system "opam", "exec", "--", "dune", "build", "pyre.bin", "--profile", "release"
    bin.install "_build/default/pyre.bin" => "pyre"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      i: int = 'string'
    EOS

    system "expect", "-c", <<~EOS
      spawn #{bin}/pyre init
      expect "ƛ Also initialize watchman in the current directory? \\[Y/n\\]"
      send "Y\r"
      expect "ƛ Which directory(ies) should pyre analyze? (Default: `.`):"
      send ".\r"
      expect eof
    EOS

    output = shell_output("#{bin}/pyre check 2>&1", 1)
    assert_includes "Found 1 type error", output
    assert_match "test.py:1:0 Incompatible variable type [9]: i is declared to have type `int` " \
                 "but is used as type `str`.", output
  end
end
