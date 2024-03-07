class Internetarchive < Formula
  include Language::Python::Virtualenv

  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/internetarchive"
  url "https://files.pythonhosted.org/packages/c0/e2/9d665fe3a65119894f4f1eb64404b0f53d4542ea841af271a834b444b1a4/internetarchive-3.6.0.tar.gz"
  sha256 "86c011e23751f5dff1d5cc6e3bc610b2eca3331d5e502c1cd34c2021068b6bbd"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71932d49487fc1d8ecb14a97092836555d56fe6b53b77e9f07a06cdf80bc62dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "820d5b917f3a2baea05efdb587bbb61be4a8213042bb74cfd1a9bd3875cc93f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd6f0ff1271f8cd6f9ce45d825306f38d0edadc36b0fab0dbc23e19128550d81"
    sha256 cellar: :any_skip_relocation, sonoma:         "04c0973ff86daf03e138f5b81751a2c254f23f00d655f26bf31868daab36db9b"
    sha256 cellar: :any_skip_relocation, ventura:        "ddb30e6972c247fc70c794bdf82bc2d525efbbf0942d9553febf5bd19d2c1440"
    sha256 cellar: :any_skip_relocation, monterey:       "ec32f72b766036e97db97bf051b53fc7ae51299956337cdc1372376a6df8e27e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9c400b1ae92f77ceb65e3bdb1b5e6e07b1870d6890f166e2a331137a2587c1"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  # Drop setuptools dep
  # https://github.com/jjjake/internetarchive/pull/621
  patch :DATA

  def install
    ENV["PIP_USE_PEP517"] = "1"
    virtualenv_install_with_resources
  end

  test do
    metadata = JSON.parse shell_output("#{bin}/ia metadata tigerbrew")
    assert_equal metadata["metadata"]["uploader"], "mistydemeo@gmail.com"
  end
end

__END__
From 7f882e7d25c7baaadca1f9abf014f8c16f7e76d0 Mon Sep 17 00:00:00 2001
From: Letu Ren <fantasquex@gmail.com>
Date: Tue, 9 Jan 2024 18:28:50 +0800
Subject: [PATCH] Switch to importlib-metadata to drop deprecated pkg_resources

According to https://setuptools.pypa.io/en/latest/pkg_resources.html,
pkg_resources has been deprecated and importlib-metadata is recommended.
`DistributionNotFound` only can be thrown from `find_plugins()` which is
not used by ia. Tested with plugin
https://github.com/JesseWeinstein/ia_recent.

Closes: https://github.com/jjjake/internetarchive/issues/613
---
 internetarchive/cli/ia.py | 6 +++---
 setup.cfg                 | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/internetarchive/cli/ia.py b/internetarchive/cli/ia.py
index 8e044c36..9a5b2c70 100755
--- a/internetarchive/cli/ia.py
+++ b/internetarchive/cli/ia.py
@@ -64,7 +64,7 @@
 import sys

 from docopt import docopt, printable_usage
-from pkg_resources import DistributionNotFound, iter_entry_points
+from importlib.metadata import entry_points
 from schema import Or, Schema, SchemaError  # type: ignore[import]

 from internetarchive import __version__
@@ -97,11 +97,11 @@ def load_ia_module(cmd: str):
             return __import__(_module, fromlist=['internetarchive.cli'])
         else:
             _module = f'ia_{cmd}'
-            for ep in iter_entry_points('internetarchive.cli.plugins'):
+            for ep in entry_points(group='internetarchive.cli.plugins'):
                 if ep.name == _module:
                     return ep.load()
             raise ImportError
-    except (ImportError, DistributionNotFound):
+    except (ImportError):
         print(f"error: '{cmd}' is not an ia command! See 'ia help'",
               file=sys.stderr)
         matches = '\t'.join(difflib.get_close_matches(cmd, cmd_aliases.values()))
