class PscPackage < Formula
  desc "Package manager for PureScript based on package sets"
  homepage "https://psc-package.readthedocs.io"
  url "https://github.com/purescript/psc-package/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "96c3bf2c65d381c61eff3d16d600eadd71ac821bbe7db02acec1d8b3b6dbecfc"
  license "BSD-3-Clause"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d0b451d9760801f148494b4e3e0038186fdd645a2099f43a8209e4c67593ed4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "caa3fd862fbd5b0fee519827956ee81da5cb790c8f4818b63c25e4e3b4647f9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60ce822c848d09c9d477d37c8c3e7667ffae266897f06d538368c5d66746e1f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d218b3190d7af58a6dee769d8fc8b0543ac7eed760af9552b871ec9e6c28b918"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f896fa8803f8405c76b6814302c9a81bc88ad63facccf653f302ca6c7314862"
    sha256 cellar: :any_skip_relocation, sonoma:         "2745b40b2ca64e1a6e369b79ab2c3141ea04c84538d335be866978c594e2bde6"
    sha256 cellar: :any_skip_relocation, ventura:        "34a6d89e4900fadd0f3844622d53df285ab26a54fb2b46c61191bd6b1b835c29"
    sha256 cellar: :any_skip_relocation, monterey:       "c96222df112a5a511469867e560157aab7ffc0fba812261302ac227fc682aebe"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "680bb83343573560dfa3bc8628fcb60ef41ec5f116fba1e0cec88f81f3d0fb40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57150c2dfc8edce29db3b116563bb83d58c573b95cf497381a711f960f804378"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "purescript"

  # Apply upstream patch to fix build. Remove with next release.
  patch do
    url "https://github.com/purescript/psc-package/commit/2817cfd7bbc29de790d2ab7bee582cd6167c16b5.patch?full_index=1"
    sha256 "e49585ff8127ccca0b35dc8a7caa04551de1638edfd9ac38e031d1148212091c"
  end

  # Another patch to fix build. See https://github.com/purescript/psc-package/pull/169.
  patch :DATA

  def install
    # Workaround to build with GHC 9.10 until upstream allows `turtle >= 1.6`
    args = ["--allow-newer=turtle:text"]

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
