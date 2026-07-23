class PscPackage < Formula
  desc "Package manager for PureScript based on package sets"
  homepage "https://psc-package.readthedocs.io"
  url "https://github.com/purescript/psc-package/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "96c3bf2c65d381c61eff3d16d600eadd71ac821bbe7db02acec1d8b3b6dbecfc"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 4
    sha256 cellar: :any, arm64_tahoe:   "f6c81d6b073711eed4bf20c42410ca4ad7d2d669237ecf6def5804c8cc29343d"
    sha256 cellar: :any, arm64_sequoia: "a14fb9e6b68780fbec104443cd58fe7b04251878c4db46366c935a130df02608"
    sha256 cellar: :any, arm64_sonoma:  "64b9d40b022646fa005b18f6f6dceee95926d643f9094fc750572721919748d6"
    sha256 cellar: :any, sonoma:        "3f19426b0c3f3bf4b984094eccd350cbd60b92804441edaeda4aff786b479d4b"
    sha256 cellar: :any, arm64_linux:   "20af68b4b390cae1e31e867b482a95f0f54794fbb26439baf00cd65f1cf9159c"
    sha256 cellar: :any, x86_64_linux:  "9338eb156b117da211f19a7f2d82a1ccc318e55cc67e1b459ba66e9f9edd93ff"
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
    type :backport
    resolves "https://github.com/purescript/psc-package/pull/168"
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
