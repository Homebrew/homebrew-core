class Iconsur < Formula
  include Language::Python::Virtualenv

  desc "macOS Big Sur Adaptive Icon Generator"
  homepage "https://github.com/rikumi/iconsur"
  # Keep extra_packages in pypi_formula_mappings.json aligned with
  # https://github.com/rikumi/iconsur/blob/#{version}/src/fileicon.sh#L230
  url "https://registry.npmjs.org/iconsur/-/iconsur-1.7.0.tgz"
  sha256 "d732df6bbcaf1418c6f46f9148002cbc1243814692c1c0e5c0cebfcff001c4a1"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e15acf0ca74a39af601070861cc784c36a10d6ec8b423723e42f18560bb20587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41e638854049735d75d8a5817f49c5751f423ecb8d4da508fa2546c0af6092e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04e27b7499dedbce8368ea0bf753b37dc0ba0aa1e40afa60fbe1200f7c07363f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc350d8b15f1417e7b52a8ea40b7a3331d9153194a43e332878d5ea89dd1fb12"
    sha256 cellar: :any_skip_relocation, sonoma:         "44693cd5a395695bf5900720a3049b9d87753c3b36d16807acf012bba65b422f"
    sha256 cellar: :any_skip_relocation, ventura:        "83853903cd670285e187e2119a6ec16dea4a834bc36558a5821354d03391600c"
    sha256 cellar: :any_skip_relocation, monterey:       "036e74c813e250b333a2ad2f767cfda92deacc144dad0f30e12ec6bc414ef439"
  end

  depends_on :macos
  depends_on "node"

  # Uses /usr/bin/python on older macOS. Otherwise, it will use python3 from PATH.
  # Since fileicon.sh runs `pip3 install --user` to install any missing packages,
  # this causes issues if a user has Homebrew Python installed (EXTERNALLY-MANAGED).
  # We instead prepare a virtualenv with all missing packages.
  on_monterey :or_newer do
    depends_on "python@3.12"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/50/d5/0b93cb9dc94ab4b78b2b7aa54c80f037e4de69897fff81a5ededa91d2704/pyobjc-core-10.1.tar.gz"
    sha256 "1844f1c8e282839e6fdcb9a9722396c1c12fb1e9331eb68828a26f28a3b2b2b1"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/5d/1d/964a0da846d49511489bd99ed705f9d85c5081fc832d0dba384c4c0d2fb2/pyobjc-framework-Cocoa-10.1.tar.gz"
    sha256 "8faaf1292a112e488b777d0c19862d993f3f384f3927dc6eca0d8d2221906a14"
  end

  def install
    system "npm", "install", *std_npm_args

    if MacOS.version >= :monterey
      venv = virtualenv_create(libexec/"venv", "python3.12")
      venv.pip_install resources
      bin.install Dir["#{libexec}/bin/*"]
      bin.env_script_all_files libexec/"bin", PATH: "#{venv.root}/bin:${PATH}"
    else
      bin.install_symlink Dir["#{libexec}/bin/*"]
    end
  end

  test do
    mkdir testpath/"Test.app"
    system bin/"iconsur", "set", testpath/"Test.app", "-k", "AppleDeveloper"
    system bin/"iconsur", "cache"
    system bin/"iconsur", "unset", testpath/"Test.app"
  end
end
