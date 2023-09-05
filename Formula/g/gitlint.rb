class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.com/gitlint/"
  url "https://files.pythonhosted.org/packages/73/51/b59270264aabcab5b933f3eb9bfb022464ca9205b04feef1bdc1635fd9b4/gitlint_core-0.19.1.tar.gz"
  sha256 "7bf977b03ff581624a9e03f65ebb8502cc12dfaa3e92d23e8b2b54bbdaa29992"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d405098bd2a0e76aa35c2c962a78047eb9813bd2e8137d32e77465ec65a1baa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "729efc2e3ad555e6d77fa801042a157bfa2182738794a1b80fd4345aa0b8ef30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c0961fb81b39f533e9448b51f62579be7fd2870ad96b05bf06ece1dc0cf9d4a"
    sha256 cellar: :any_skip_relocation, ventura:        "7d3d8661621b9a761425df188984da146c615f5a2d9e89d29615f86d2ebb4ce2"
    sha256 cellar: :any_skip_relocation, monterey:       "c25ba5a796a144b68544c08eb44a1d23f89448b42c7195e6637e3a21c214f710"
    sha256 cellar: :any_skip_relocation, big_sur:        "c75117e820488a1eeeef95548342f64632e626c8c31b2570f769faa15a3a6ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e15b677036ec1ede61fdc4d533fc92f20e0faa99f29c2eeaa7b713b176ad1c0c"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/ff/c7/0c170c7dde31f088f3c8221f90e054b121b5bd36f9e6f94edca4fdb64c0c/sh-2.0.2.tar.gz"
    sha256 "364a25cd2380c3170c46718fe3cc6ffc94b36721e30196a064be508f9b3162f4"
  end

  def install
    virtualenv_install_with_resources

    # Click does not support bash version older than 4.4
    generate_completions_from_executable(bin/"gitlint", shells:                 [:fish, :zsh],
                                                        shell_parameter_format: :click)
  end

  test do
    # Install gitlint as a git commit-msg hook
    system "git", "init"
    system "#{bin}/gitlint", "install-hook"
    assert_predicate testpath/".git/hooks/commit-msg", :exist?

    # Verifies that the second line of the hook is the title
    output = File.open(testpath/".git/hooks/commit-msg").each_line.take(2).last
    assert_equal "### gitlint commit-msg hook start ###\n", output
  end
end
