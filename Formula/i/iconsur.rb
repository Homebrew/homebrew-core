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
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70712f66d8b596a4a71981e100c79defd6830fdac4d7785496361bb2d88663c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a387505aeabe3db495e15a9dda242feffe56d2a1b8d5098bce8f992a691813b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e104a5588b9c5c798afff7bda2adb98de20d0aead8759c7b8148cd256d0386e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "882cf1ad86e392edff824cb1a32414f4ba714ffbc77823af315ecc81458b8f17"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c44aa9c8fb87a78d48de33645c812fe818a9e98840c58c096cc50c4997a3da5"
    sha256 cellar: :any_skip_relocation, ventura:       "bd2baf85e6dce0f61e8e5313e2333022e88704ba80c515e0893103b5320a9531"
  end

  depends_on :macos
  depends_on "node"

  # Uses /usr/bin/python on older macOS. Otherwise, it will use python3 from PATH.
  # Since fileicon.sh runs `pip3 install --user` to install any missing packages,
  # this causes issues if a user has Homebrew Python installed (EXTERNALLY-MANAGED).
  # We instead prepare a virtualenv with all missing packages.
  on_monterey :or_newer do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "python@3.13"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/e8/e9/0b85c81e2b441267bca707b5d89f56c2f02578ef8f3eafddf0e0c0b8848c/pyobjc_core-11.1.tar.gz"
    sha256 "b63d4d90c5df7e762f34739b39cc55bc63dbcf9fb2fb3f2671e528488c7a87fe"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/4b/c5/7a866d24bc026f79239b74d05e2cf3088b03263da66d53d1b4cf5207f5ae/pyobjc_framework_cocoa-11.1.tar.gz"
    sha256 "87df76b9b73e7ca699a828ff112564b59251bb9bbe72e610e670a4dc9940d038"
  end

  def install
    system "npm", "install", *std_npm_args

    if MacOS.version >= :monterey
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
      # pyobjc-core uses "-fdisable-block-signature-string" introduced in clang 17
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1699

      venv = virtualenv_create(libexec/"venv", "python3.13")
      venv.pip_install resources
      bin.install libexec.glob("bin/*")
      bin.env_script_all_files libexec/"bin", PATH: "#{venv.root}/bin:${PATH}"
    else
      bin.install_symlink libexec.glob("bin/*")
    end
  end

  test do
    mkdir testpath/"Test.app"
    system bin/"iconsur", "set", testpath/"Test.app", "-k", "AppleDeveloper"
    system bin/"iconsur", "cache"
    system bin/"iconsur", "unset", testpath/"Test.app"
  end
end
