class PscPackage < Formula
  desc "Package manager for PureScript based on package sets"
  homepage "https://psc-package.readthedocs.io"
  url "https://github.com/purescript/psc-package/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "96c3bf2c65d381c61eff3d16d600eadd71ac821bbe7db02acec1d8b3b6dbecfc"
  license "BSD-3-Clause"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "b1489b1776cdab0800397074dbb0ec35a89ad1038e8cf35243cc9a6c452e1355"
    sha256 cellar: :any,                 arm64_sequoia: "74cbe29713b84ceac9b1e0805c3585905d239c8c09692ee9fffaf24fc0c24fcd"
    sha256 cellar: :any,                 arm64_sonoma:  "82d40bcd3e5b27f749a1c6fb8cc8707805844928200c9c0e6fb03d8248afb61f"
    sha256 cellar: :any,                 sonoma:        "1fb1adcb05550a799c54784b0141d3b8877766fd8845543e1ec05130b2e8bdcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3084a949cb92ad9b031bcf3b4bb96f6fd607073dbf86868826041794335ec9f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f15621b52993c984fd4efa03e350ead5b93353ce17bf734f28788b8288525d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "purescript"

  uses_from_macos "libffi"

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
