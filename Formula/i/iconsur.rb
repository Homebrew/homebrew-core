require "language/node"

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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34926c4bd6b066a9ca422ad09daa4a04c7b3ac40e6e094eec10a74a3f3ffce9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c89a0bafa76e65252ca37540e7e80079894ef63150c4d29fdbaa2f92ce04359"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "304d38f9248f8979b2b483280cac76690c14b61ff87f08484c0dc2a9387c21b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "304d38f9248f8979b2b483280cac76690c14b61ff87f08484c0dc2a9387c21b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5755fcf3326e667794b2cec721d12d5488c34da0ba53b977d7c5431e079ed7b"
    sha256 cellar: :any_skip_relocation, ventura:        "eaf5ee9a4bc080056cf6ea44e633660b90309b201d17b4b7165eaa3e62656d63"
    sha256 cellar: :any_skip_relocation, monterey:       "77884a43974a1b6a917d415b12d2b6fe476dee4215e986e7123b9d911b0a95cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "77884a43974a1b6a917d415b12d2b6fe476dee4215e986e7123b9d911b0a95cc"
    sha256 cellar: :any_skip_relocation, catalina:       "77884a43974a1b6a917d415b12d2b6fe476dee4215e986e7123b9d911b0a95cc"
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
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

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
