class GitReview < Formula
  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/8e/5c/18f534e16b193be36d140939b79a8046e07f343b426054c084b12d59cf0b/git-review-2.3.1.tar.gz"
  sha256 "24e938136eecb6e6cbb38b5e2b034a286b70b5bb8b5a2853585c9ed23636014f"
  license "Apache-2.0"
  revision 3
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d5d414cdf10919defc6b017799249cdb150fbe3bd64ea3ac4f155037c52fc90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db17a9e895ee7d18eddfe94b6c3c3798b3020a7a793039f410c9331232739157"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b6646591dc77bca2e0825bfd0a0ab61260ef9915444f61ac783b6a194769f32"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb8c641a5531c73335e61314cc08da60d19f86670150b410a9d6729fa0ac7cac"
    sha256 cellar: :any_skip_relocation, ventura:        "22c31a9c79bc2b4aefb797ea12d89b90f03ab20f8220e0a42493df00ec5b82a7"
    sha256 cellar: :any_skip_relocation, monterey:       "72dc7edeae00453acda5d92736f375e96e1e9196ce44619aebfe56e3f1604e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81911c588fb66a24bf496193671a967d8a342a96596e45737eaafa0df542d2f2"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  # Drop setuptools dep
  # https://review.opendev.org/c/opendev/git-review/+/907101
  patch :DATA

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
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
