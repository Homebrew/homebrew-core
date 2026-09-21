class Iconsur < Formula
  include Language::Python::Virtualenv

  desc "macOS Big Sur Adaptive Icon Generator"
  homepage "https://github.com/rikumi/iconsur"
  # Keep extra `pypi_packages` aligned with
  # https://github.com/rikumi/iconsur/blob/#{version}/src/fileicon.sh#L230
  url "https://registry.npmjs.org/iconsur/-/iconsur-1.7.0.tgz"
  sha256 "d732df6bbcaf1418c6f46f9148002cbc1243814692c1c0e5c0cebfcff001c4a1"
  license "MIT"

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8092c4a573094e89a8370d965d103a32d6c8884f7ff9a6437d12d8bc3404819"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d498225ce7ab40121942e4b3358464704680d67ab13acf6d7940acddd4aeca2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f7e4d6cf6f6a7208f43c28faf77088949eb4adf41a73b7cb9239dcafaf4625a"
  end

  deprecate! date: "2026-08-01", because: :repo_archived
  disable! date: "2027-02-01", because: :repo_archived

  depends_on :macos
  depends_on "node"

  # Uses /usr/bin/python on older macOS. Otherwise, it will use python3 from PATH.
  # Since fileicon.sh runs `pip3 install --user` to install any missing packages,
  # this causes issues if a user has Homebrew Python installed (EXTERNALLY-MANAGED).
  # We instead prepare a virtualenv with all missing packages.
  on_monterey :or_newer do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "python@3.14"

    fails_with :clang do
      build 1699
      cause "pyobjc-core uses `-fdisable-block-signature-string`"
    end
  end

  pypi_packages package_name:   "",
                extra_packages: ["pyobjc-core", "pyobjc-framework-cocoa"]

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
      # `pyobjc-core` needs Apple's `libffi` extensions, so keep `node`'s `libffi` out of the link
      ENV.remove "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("libffi")

      venv = virtualenv_create(libexec/"venv", python3)
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
