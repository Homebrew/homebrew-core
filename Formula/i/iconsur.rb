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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba4be0ff656530a2a787c34d2b8c9502a0bb6448dd3d76198ff9d9a295769303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c5b0753cf7a6dd13ecc8fa8ca6d8e511f1f8658a907e793e8cce001164f669a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81f49f558f09ca338470b0599e6c8e2254a85b31e7a098dada4dac32bd5f2de5"
    sha256 cellar: :any_skip_relocation, sonoma:        "80a8c9d1251b6015fa7070d4a07a82fe39b6b70d2a1bf148a468cf8f28dd9467"
    sha256 cellar: :any_skip_relocation, ventura:       "652b5bdaa7162f802914ec320be23b44f1984f58a967cb5488dfa354a46b678c"
  end

  depends_on :macos
  depends_on "node"

  # Uses /usr/bin/python on older macOS. Otherwise, it will use python3 from PATH.
  # Since fileicon.sh runs `pip3 install --user` to install any missing packages,
  # this causes issues if a user has Homebrew Python installed (EXTERNALLY-MANAGED).
  # We instead prepare a virtualenv with all missing packages.
  on_monterey :or_newer do
    depends_on "python@3.13"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b7/40/a38d78627bd882d86c447db5a195ff307001ae02c1892962c656f2fd6b83/pyobjc_core-10.3.1.tar.gz"
    sha256 "b204a80ccc070f9ab3f8af423a3a25a6fd787e228508d00c4c30f8ac538ba720"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/a7/6c/b62e31e6e00f24e70b62f680e35a0d663ba14ff7601ae591b5d20e251161/pyobjc_framework_cocoa-10.3.1.tar.gz"
    sha256 "1cf20714daaa986b488fb62d69713049f635c9d41a60c8da97d835710445281a"

    # Backport commit to avoid Xcode.app dependency. Remove in the next release
    # https://github.com/ronaldoussoren/pyobjc/commit/864a21829c578f6479ac6401d191fb759215175e
    patch :DATA
  end

  def install
    system "npm", "install", *std_npm_args

    if MacOS.version >= :monterey
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"

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

__END__
--- a/pyobjc_setup.py
+++ b/pyobjc_setup.py
@@ -510,15 +510,6 @@ def Extension(*args, **kwds):
             % (tuple(map(int, os_level.split(".")[:2])))
         )
 
-    # XCode 15 has a bug w.r.t. weak linking for older macOS versions,
-    # fall back to older linker when using that compiler.
-    # XXX: This should be in _fixup_compiler but doesn't work there...
-    lines = subprocess.check_output(["xcodebuild", "-version"], text=True).splitlines()
-    if lines[0].startswith("Xcode"):
-        xcode_vers = int(lines[0].split()[-1].split(".")[0])
-        if xcode_vers >= 15:
-            ldflags.append("-Wl,-ld_classic")
-
     if os_level == "10.4":
         cflags.append("-DNO_OBJC2_RUNTIME")
