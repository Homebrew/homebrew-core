class PscPackage < Formula
  desc "Package manager for PureScript based on package sets"
  homepage "https://psc-package.readthedocs.io"
  url "https://github.com/purescript/psc-package/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "96c3bf2c65d381c61eff3d16d600eadd71ac821bbe7db02acec1d8b3b6dbecfc"
  license "BSD-3-Clause"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "853fa3c46cc3d8014091d14617d648cb6b6b93f4c12bde49197b53fe213f85a6"
    sha256 cellar: :any,                 arm64_sequoia: "6c5928de908600c114d1586d02da4c506a7b19c5cbf575eb1b7f59601b2af724"
    sha256 cellar: :any,                 arm64_sonoma:  "be21d5ebf43c62b97943a8f695aaeb4c089d09e758025e09fc5d331ff94958cb"
    sha256 cellar: :any,                 sonoma:        "cfbcf399e9fa7c9ae00731f65705c19e13484e8b4f90f40b355de009eab70d37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b95340cc6d47cb4a2a0a39e28a6a2f9e5ea9f053610f370dc598687c1f3d85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c39f2e672013bcc94c77c15c585fc01bafaacbb74026cda1d720bc75b991d876"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "purescript"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Apply upstream patch to fix build. Remove with next release.
  patch do
    url "https://github.com/purescript/psc-package/commit/2817cfd7bbc29de790d2ab7bee582cd6167c16b5.patch?full_index=1"
    sha256 "e49585ff8127ccca0b35dc8a7caa04551de1638edfd9ac38e031d1148212091c"
  end

  # Another patch to fix build. See https://github.com/purescript/psc-package/pull/169.
  patch :DATA

  def install
    # Workaround to build with GHC 9.10 until upstream allows `turtle >= 1.6`
    args = ["--allow-newer=base,turtle:text"]

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args << "--allow-newer=containers,template-haskell"

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    assert_match "Initializing new project in current directory", shell_output("#{bin}/psc-package init --set=master")
    package_json = (testpath/"psc-package.json").read
    package_hash = JSON.parse(package_json)
    assert_match "master", package_hash["set"]
    assert_match "Install complete", shell_output("#{bin}/psc-package install")
  end
end

__END__
diff --git a/app/Types.hs b/app/Types.hs
index e0a6b73..3614dab 100644
--- a/app/Types.hs
+++ b/app/Types.hs
@@ -10,6 +10,7 @@ module Types
 
 import           Control.Category ((>>>))
 import           Data.Aeson (FromJSON, ToJSON, FromJSONKey(..), ToJSONKey(..), ToJSONKeyFunction(..), FromJSONKeyFunction(..), parseJSON, toJSON, withText)
+import           Data.Aeson.Types (toJSONKeyText)
 import qualified Data.Aeson.Encoding as AesonEncoding
 import           Data.Char (isAscii, isLower, isDigit)
 import           Data.Text (Text)
@@ -34,9 +35,7 @@ fromText t =
 
 instance ToJSONKey PackageName where
   toJSONKey =
-    ToJSONKeyText
-      runPackageName
-      (AesonEncoding.text . runPackageName)
+    toJSONKeyText runPackageName
 
 instance FromJSONKey PackageName where
   fromJSONKey =
