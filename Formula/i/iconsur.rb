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
    rebuild 7
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f60c044dafbbb7f75a1e0a9b55efc3d429749961044d245da05b4b96fc8187c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f2cbd7f353be756075437e67072e0a3b57c89aea19e9b625c92d79f563f4be2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0abdcb49c8b930bb913ccfd43096e4b08899c0f97a3860f32ab7ca8c260beb7e"
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
    depends_on "python@3.15"

    fails_with :clang do
      build 1699
      cause "pyobjc-core uses `-fdisable-block-signature-string`"
    end
  end

  pypi_packages package_name:   "",
                extra_packages: ["pyobjc-core", "pyobjc-framework-cocoa"]

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/83/58/7bab095330b8893e1ac58f3cf9710462c3242b600f8fa5db0d5dda795775/pyobjc_core-13.0.tar.gz"
    sha256 "ffe154462d14aa4852f424e9116f17b5f8d44f78fc0f6c4727e721a5fa7177da"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/30/50/55a8779d35f1f86d795264cbd6fe62e35b2cf4fb8343fc888e99268c988a/pyobjc_framework_cocoa-13.0.tar.gz"
    sha256 "bb7a23941fc8d7866578dbc84e56140efd343a1d28510f530dd1dbf80807daf4"
  end

  def install
    system "npm", "install", *std_npm_args

    if MacOS.version >= :monterey
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
      # Make `pyobjc-core` detect the SDK that superenv compiles with rather than the newer Xcode one
      ENV["SDKROOT"] = MacOS.sdk_path
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
