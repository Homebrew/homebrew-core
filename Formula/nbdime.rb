class Nbdime < Formula
  include Language::Python::Virtualenv

  desc "Jupyter Notebook Diff and Merge tools"
  homepage "https://nbdime.readthedocs.io"
  url "https://files.pythonhosted.org/packages/e1/36/28232d030c1b4a25116799f1aa3cd26208964f302daa324c314fd576820a/nbdime-3.1.1.tar.gz"
  sha256 "67767320e971374f701a175aa59abd3a554723039d39fae908e72d16330d648b"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "293eafe8fa077130dc17da07557e8d009c4e2d0e2210c1ac9a658eba9d79797c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1553392c5720fd680644d4d617abebe012ece27b89c1fe96aeb9b7e968f5d896"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a33accd3f14e9c11a65be4c198cffbbd2f8e5275d4aa0359d1b5800528074540"
    sha256 cellar: :any_skip_relocation, ventura:        "438e55d4b673b9a866a83de50a315daaed0d50c23358edb6f24ee243f4e1afdd"
    sha256 cellar: :any_skip_relocation, monterey:       "e84db732813f0b699bed48ead024f4a98237e01afc1d27a5b2b920e5c036f6c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a1c6227149374482850bd68647cdbc003fd937fadd00e87e525e630e38dd3b6"
    sha256 cellar: :any_skip_relocation, catalina:       "b84dcbdc0504a31ab8cb2c7ec1ad0a2f4bda29856d36488ca7e89d5f0d7c7d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c9299e7491f83c4970692f3a5a0626e7732be192473fe64a4ee7470fc68a5a9"
  end

  depends_on "ipython"
  depends_on "jupyterlab"
  depends_on "python@3.11"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ef/8d/50658d134d89e080bb33eb8e2f75d17563b5a9dfb75383ea1a78e1df6fff/GitPython-3.1.30.tar.gz"
    sha256 "769c2d83e13f5d938b7688479da374c4e3d49f71549aaf462b646db9602ea6f8"
  end

  resource "jupyter-server-mathjax" do
    url "https://files.pythonhosted.org/packages/9c/40/9a1b8c2a2e44e8e2392174cd8e52e0c976335f004301f61b66addea3243e/jupyter_server_mathjax-0.2.6.tar.gz"
    sha256 "bb1e6b6dc0686c1fe386a22b5886163db548893a99c2810c36399e9c4ca23943"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  # Backport fix to build with Python 3.11. Upstream commit doesn't apply due
  # to CRLF line terminators used in PyPI tarball. Remove in the next release.
  # Ref: https://github.com/jupyter/nbdime/commit/f50376344db8ba01f1aff0b65f39ead7a3ed2405
  patch :DATA

  def python3
    "python3.11"
  end

  def install
    inreplace "pyproject.toml",
      'requires = ["jupyterlab~=3.0", "setuptools>=40.8.0", "wheel"]',
      'requires = ["setuptools>=40.8.0", "wheel"]'

    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages(python3)
    %w[jupyterlab ipython].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end
  end

  test do
    (testpath/"old.ipynb").write <<~EOS
      {
       "cells": [
        {
         "cell_type": "code",
         "execution_count": null,
         "metadata": {},
         "outputs": [],
         "source": [
          "print(\\"Hello World!\\")"
         ]
        }
       ],
       "metadata": {
        "kernelspec": {
         "display_name": "Python 2",
         "language": "python",
         "name": "python2"
        },
        "language_info": {
         "codemirror_mode": {
          "name": "ipython",
          "version": 2
         },
         "file_extension": ".py",
         "mimetype": "text/x-python",
         "name": "python",
         "nbconvert_exporter": "python",
         "pygments_lexer": "ipython2",
         "version": "2.7.10"
        }
       },
       "nbformat": 4,
       "nbformat_minor": 1
      }
    EOS
    (testpath/"new.ipynb").write <<~EOS
      {
       "cells": [
        {
         "cell_type": "code",
         "execution_count": 1,
         "metadata": {},
         "outputs": [
          {
           "name": "stdout",
           "output_type": "stream",
           "text": [
            "Hello World!\\n"
           ]
          }
         ],
         "source": [
          "print(\\"Hello World!\\")"
         ]
        }
       ],
       "metadata": {
        "kernelspec": {
         "display_name": "Python 2",
         "language": "python",
         "name": "python2"
        },
        "language_info": {
         "codemirror_mode": {
          "name": "ipython",
          "version": 2
         },
         "file_extension": ".py",
         "mimetype": "text/x-python",
         "name": "python",
         "nbconvert_exporter": "python",
         "pygments_lexer": "ipython2",
         "version": "2.7.10"
        }
       },
       "nbformat": 4,
       "nbformat_minor": 1
      }
    EOS
    # sadly no special exit code if files are the same
    diff_output = shell_output("#{bin}/nbdiff --no-color old.ipynb new.ipynb")
    assert_match "nbdiff old.ipynb new.ipynb", diff_output
    assert_match(/--- old.ipynb  \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{6}/, diff_output)
    assert_match(/\+\+\+ new.ipynb  \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{6}/, diff_output)
  end
end

__END__
diff --git a/setupbase.py b/setupbase.py
index 6a63572..aebfd41 100644
--- a/setupbase.py
+++ b/setupbase.py
@@ -661,7 +661,7 @@ def _translate_glob(pat):
         translated_parts.append(_translate_glob_part(part))
     os_sep_class = '[%s]' % re.escape(SEPARATORS)
     res = _join_translated(translated_parts, os_sep_class)
-    return '{res}\\Z(?ms)'.format(res=res)
+    return '(?ms){res}\\Z'.format(res=res)
 
 
 def _join_translated(translated_parts, os_sep_class):
