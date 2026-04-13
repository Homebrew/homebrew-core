class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/a6/12/92bbf5db0eac6d901ccca51f001b64a4a57f8b06d7189147cd3c9ee570ce/parliament-1.6.4.tar.gz"
  sha256 "ea6b930de2afd2f1591d5624b56b8c9361e746c76ce50a9586cab209054dfa4c"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "60bddf774d95d7f871717cbceee1a971599b5f75e1637e5144ff9fa99723879d"
    sha256 cellar: :any,                 arm64_sequoia: "f365810c0ac11fb66db708f651859e9790e8e1698d0286a1e2fc90fc84a7fb5f"
    sha256 cellar: :any,                 arm64_sonoma:  "ee4156d8f0b1368be3a4536db2f88c8209529e38b2526b4111b252994723f36b"
    sha256 cellar: :any,                 sonoma:        "fa500360843e43e5951a7b534fb9f33a4789be54c80b540cb67c97cc60f1512b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28c048903b04e7ff1b8e190bb18b5ada6099886049525cc42c2659d032e11d4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b9518ad78b163c3082b7f29cc084ec6f3972418d09367c7a75a82a9da939aa6"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/59/41/7a7280875ec000e280b0392478a5d6247bc88e7ecf2ae6ec8f4ddb35b014/boto3-1.42.50.tar.gz"
    sha256 "38545d7e6e855fefc8a11e899ccbd6d2c9f64671d6648c2acfb1c78c1057a480"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/93/fd/e63789133b2bf044c8550cd6766ec93628b0ac18a03f2aa0b80171f0697a/botocore-1.42.50.tar.gz"
    sha256 "de1e128e4898f4e66877bfabbbb03c61f99366f27520442539339e8a74afe3a5"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "json-cfg" do
    url "https://files.pythonhosted.org/packages/70/d8/34e37fb051be7c3b143bdb3cc5827cb52e60ee1014f4f18a190bb0237759/json-cfg-0.4.2.tar.gz"
    sha256 "d3dd1ab30b16a3bb249b6eb35fcc42198f9656f33127e36a3fadb5e37f50d45b"
  end

  resource "kwonly-args" do
    url "https://files.pythonhosted.org/packages/ee/da/a7ba4f2153a536a895a9d29a222ee0f138d617862f9b982bd4ae33714308/kwonly-args-1.0.10.tar.gz"
    sha256 "59c85e1fa626c0ead5438b64f10b53dda2459e0042ea24258c9dc2115979a598"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  # Replace `pkg_resources` for Python 3.12+: https://github.com/duo-labs/parliament/pull/258
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject', " \
                 "'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}",
    pipe_output("#{bin}/parliament --string '{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}'").strip
  end
end

__END__
diff --git a/parliament/__init__.py b/parliament/__init__.py
index ea32a6f..6254b71 100644
--- a/parliament/__init__.py
+++ b/parliament/__init__.py
@@ -10,16 +10,18 @@ import json
 import jsoncfg
 import re
 
-import pkg_resources
+from importlib.resources import files, as_file
 import yaml
 
 # On initialization, load the IAM data
-iam_definition_path = pkg_resources.resource_filename(__name__, "iam_definition.json")
-iam_definition = json.load(open(iam_definition_path, "r"))
+iam_definition_path = files(__name__) / "iam_definition.json"
+with as_file(iam_definition_path) as path:
+    iam_definition = json.loads(path.read_text())
 
 # And the config data
-config_path = pkg_resources.resource_filename(__name__, "config.yaml")
-config = yaml.safe_load(open(config_path, "r"))
+config_path = files(__name__) / "config.yaml"
+with as_file(config_path) as path:
+    config = yaml.safe_load(path.read_text())
 
 
 def override_config(override_config_path):
