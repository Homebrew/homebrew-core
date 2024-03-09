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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e67e0fa5d12b5598bb3f6755547a50e20da472da57a7df5c68d2ca3380f7140"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdfdf024544f90244bfefea1697a7100c7e2adde6a05fd51a4e4e54c5f3ebc98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11889c0c42c2a044fe9dc081f50cf332f606e922837b5a765141ef2340e0cdb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "488565e07e909605382b2ed833216e8b87ac499225443e2b2ace61f1508b6a6b"
    sha256 cellar: :any_skip_relocation, ventura:        "1a1f49255b7376a223d04e38c2dbd0ef278376e161670b0fca923b94e4d12227"
    sha256 cellar: :any_skip_relocation, monterey:       "f9a727a3148a71fdda8a537c85028002fb33f7ff9a91db86a4d50971db5b4a42"
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
