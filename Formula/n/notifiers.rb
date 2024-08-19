class Notifiers < Formula
  include Language::Python::Virtualenv

  desc "Easy way to send notifications"
  homepage "https://pypi.org/project/notifiers/"
  url "https://files.pythonhosted.org/packages/54/fc/aa5de032cc8d9ee41ceba7bbea98e2ed7090d7d95465dfe0179eb937146f/notifiers-1.3.3.tar.gz"
  sha256 "9fd8d95ab1ebcd3852423755aa90cbb0f72a805ca77af0d8c9ad7af445f58399"
  license "MIT"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a654ba7afe3218566a3bd3eb708379ca4de2919540d8f2bd4cea386cdbcd565c"
    sha256 cellar: :any,                 arm64_ventura:  "2df8df638fd8296ee550f6ebc946c3872f3018657aa32988d328bebcf3f7fb55"
    sha256 cellar: :any,                 arm64_monterey: "a2c5191785c19b7d5c404dac5c95925b05f1243d420ddf584534da17a3f87347"
    sha256 cellar: :any,                 sonoma:         "824189e870222429a5b4073a99289ade707238be9ba7196956b1db9516be0896"
    sha256 cellar: :any,                 ventura:        "b9bf77d2d254ecdec2116319e26afaf58cde0c90d1483dcb9bbb4c9f4cdd0795"
    sha256 cellar: :any,                 monterey:       "3fc294d6508363278454640548e651830145a910ac06de7ada4bc652e5f5fb6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1cceec2b8032fceff1e2d9a9a205c8e004dd7b506c5cdde2be6841e27663f0a"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/19/f1/1c1dc0f6b3bf9e76f7526562d29c320fa7d6a2f35b37a1392cc0acd58263/jsonschema-4.22.0.tar.gz"
    sha256 "5b22d434a45935119af990552c862e5d6d564e8f6601206b305a61fdf661a2b7"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/2d/aa/e7c404bdee1db7be09860dff423d022ffdce9269ec8e6532cce09ee7beea/rpds_py-0.18.1.tar.gz"
    sha256 "dc48b479d540770c811fbd1eb9ba2bb66951863e448efec2e2c102625328e92f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  # Drop setuptools dep: https://github.com/liiight/notifiers/pull/470
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "notifiers", shell_output("#{bin}/notifiers --help")
  end
end

__END__
diff --git a/notifiers/utils/helpers.py b/notifiers/utils/helpers.py
index e351956..9981a0e 100644
--- a/notifiers/utils/helpers.py
+++ b/notifiers/utils/helpers.py
@@ -1,6 +1,5 @@
 import logging
 import os
-from distutils.util import strtobool
 from pathlib import Path
 
 log = logging.getLogger("notifiers")
@@ -13,7 +12,7 @@ def text_to_bool(value: str) -> bool:
     :param value: Value to check
     """
     try:
-        return bool(strtobool(value))
+        return value.lower() in {"y", "yes", "t", "true", "on", "1"}
     except (ValueError, AttributeError):
         return value is not None
 
