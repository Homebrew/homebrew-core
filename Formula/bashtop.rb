class Bashtop < Formula
  include Language::Python::Virtualenv

  desc "Bash only* alternative to top, htop, vtop, glances"
  homepage "https://github.com/aristocratos/bashtop"
  url "https://github.com/aristocratos/bashtop/archive/v0.9.16.tar.gz"
  sha256 "836a80864f85dd41fb818f30c2be789931055e45ce1a5842e739e2ec28531367"
  head "https://github.com/aristocratos/bashtop.git"

  depends_on "bash"
  depends_on "coreutils"
  depends_on "gnu-sed"
  depends_on "python@3.8"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/c4/b8/3512f0e93e0db23a71d82485ba256071ebef99b227351f0f5540f744af41/psutil-5.7.0.tar.gz"
    sha256 "685ec16ca14d079455892f25bd124df26ff9137664af445563c1bd36629b5e0e"
  end

  patch :DATA

  def install
    # install psutil resource using python3.8 dependency
    resource("psutil").stage do
      system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # mirror what Makefile for bashtop does (make has permission errors)
    bin.install "bashtop"
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      Bashtop will need to be run as superuser (sudo) on OSX to display stats for processes not owned by user (eg root).
    EOS
  end

  test do
    assert_match "function", shell_output("bash -c \"source #{bin}/bashtop && type -t main_loop\"").strip
  end
end

__END__
diff --git a/bashtop b/bashtop
index 977ba04..4536c35 100755
--- a/bashtop
+++ b/bashtop
@@ -4791,7 +4791,7 @@ if [[ $use_psutil == true ]]; then
 fi
 
 #* if we have been sourced by another shell, quit. Allows sourcing only function definition.
-[[ "${#BASH_SOURCE[@]}" -gt 1 ]] && { return 0; }
+[[ "${#BASH_SOURCE[@]}" -ge 1 ]] && { return 0; }
 
 #* Setup psutil script
 if [[ $use_psutil == true ]]; then

