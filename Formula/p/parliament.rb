class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/a6/12/92bbf5db0eac6d901ccca51f001b64a4a57f8b06d7189147cd3c9ee570ce/parliament-1.6.4.tar.gz"
  sha256 "ea6b930de2afd2f1591d5624b56b8c9361e746c76ce50a9586cab209054dfa4c"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a32fbc0d772491172bc792519e772f17254dee56a9bf10f879a8fb33374e70f"
    sha256 cellar: :any,                 arm64_sequoia: "72f87a3f3696e9056981ae3543f257e48f37398daacd513457bd8eac025d77c2"
    sha256 cellar: :any,                 arm64_sonoma:  "e5bb1e63e1d30c97ef683c7cb7620caa13bf8f337ddb69eea77938b56e69a447"
    sha256 cellar: :any,                 sonoma:        "0244eeeb1d30bd936423fcc48dc3d6cfb35e4e8ab5a38570a91cd034b519f963"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e8f093814c8483ebb6683a36cfe76e12ce125211533f96d3cd10910590c4181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd3a6866499f4272d07c91b9000135d63e514e9d8b42a540c6630f3a4ed2367"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/0a/37/78c630d1308964aa9abf44951d9c4df776546ff37251ec2434944e205c4e/boto3-1.43.6.tar.gz"
    sha256 "e6315effaf12b890b99956e6f8e2c3000a3f64e4ee91943cec3895ce9a836afb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/79/a7/23d0f5028011455096a1eeac0ddf3cbe147b3e855e127342f8202552194d/botocore-1.43.6.tar.gz"
    sha256 "b1e395b347356860398da42e61c808cf1e34b6fa7180cf2b9d87d986e1a06ba0"
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
    url "https://files.pythonhosted.org/packages/9b/ec/7c692cde9125b77e84b307354d4fb705f98b8ccad59a036d5957ca75bfc3/s3transfer-0.17.0.tar.gz"
    sha256 "9edeb6d1c3c2f89d6050348548834ad8289610d886e5bf7b7207728bd43ce33a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
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
