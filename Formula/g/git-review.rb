class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/8e/5c/18f534e16b193be36d140939b79a8046e07f343b426054c084b12d59cf0b/git-review-2.3.1.tar.gz"
  sha256 "24e938136eecb6e6cbb38b5e2b034a286b70b5bb8b5a2853585c9ed23636014f"
  license "Apache-2.0"
  revision 3
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecd033c85b9136adc4be56c4a98b66258fa1bd501acfded578b1b1625ffe034c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6d78542f921543633492fb6a011185607fc7e802f6be34c781e96c20a9d1a6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cfb8bca2b703150ef55217eb03ff4dc1662b7ff65fb9364e6810919e2b03b86"
    sha256 cellar: :any_skip_relocation, sonoma:         "17dc8b6d57e33c52ce78c2cd99a4c515102ca89d082e99473e979c3fc27d054e"
    sha256 cellar: :any_skip_relocation, ventura:        "ca3ebee625d98533abe087b7f80a5fa22c4fa78c3378a816732218d380b6b93e"
    sha256 cellar: :any_skip_relocation, monterey:       "3637833a6c6fd6fc0449718db192426f98cbe972624d76adec9a78512702e5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e5db0d2e62795718a77d3a3373214333fdecd56fa29b92f434eed5a1b0e9d2"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  # Drop setuptools dep
  # https://review.opendev.org/c/opendev/git-review/+/907101
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/brew.sh"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system bin/"git-review", "--dry-run"
  end
end

__END__
From 7b823c16e22f115684ede6bdd6bac72e258ca410 Mon Sep 17 00:00:00 2001
From: Tim Burke <tim.burke@gmail.com>
Date: Mon, 29 Jan 2024 08:58:07 -0800
Subject: [PATCH] Use importlib.metadata instead of pkg_resources

...if available. It was added in Python 3.8, and marked no-longer-
provisional in Python 3.10.

Python 3.12 no longer pre-installs setuptools in virtual environments,
which means we can no longer rely on distutils, setuptools,
pkg_resources, and easy_install being available.

Fortunately, importlib.metadata covers the one use we have of
pkg_resources.

Change-Id: Iaa68282960a1c73569f916c3b00acf7f839b9807
---

diff --git a/git_review/cmd.py b/git_review/cmd.py
index 837bfa7..d3fce69 100644
--- a/git_review/cmd.py
+++ b/git_review/cmd.py
@@ -32,9 +32,16 @@
 from urllib.parse import urljoin
 from urllib.parse import urlparse

-import pkg_resources
 import requests

+try:
+    import importlib.metadata as importlib_metadata
+    pkg_resources = None
+except ImportError:
+    # Pre-py38
+    importlib_metadata = None
+    import pkg_resources
+

 VERBOSE = False
 UPDATE = False
@@ -220,9 +227,12 @@


 def get_version():
-    requirement = pkg_resources.Requirement.parse('git-review')
-    provider = pkg_resources.get_provider(requirement)
-    return provider.version
+    if importlib_metadata:
+        return importlib_metadata.version('git-review')
+    else:
+        requirement = pkg_resources.Requirement.parse('git-review')
+        provider = pkg_resources.get_provider(requirement)
+        return provider.version


 def get_git_version():
