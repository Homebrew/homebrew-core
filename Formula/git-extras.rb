class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  head "https://github.com/tj/git-extras.git"

  stable do
    url "https://github.com/tj/git-extras/archive/4.4.0.tar.gz"
    sha256 "16c2184f13272dd032717ebd22a88762759cd10d2b9357e4ac7bd992bdd7686d"
    # Disable "git extras update", which will produce a broken install under Homebrew
    # https://github.com/Homebrew/homebrew/issues/44520
    # https://github.com/tj/git-extras/pull/491
    patch :DATA
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "77f2a8b3366b1f9016b4ef1a34a3d3b33f59d1fa8a7ffab65803ee7c0bdcd4dc" => :high_sierra
    sha256 "77f2a8b3366b1f9016b4ef1a34a3d3b33f59d1fa8a7ffab65803ee7c0bdcd4dc" => :sierra
    sha256 "77f2a8b3366b1f9016b4ef1a34a3d3b33f59d1fa8a7ffab65803ee7c0bdcd4dc" => :el_capitan
  end

  conflicts_with "git-utils",
    :because => "both install a `git-pull-request` script"

  def install
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "etc/git-extras-completion.zsh"
  end

  def caveats; <<~EOS
    To load Zsh completions, add the following to your .zschrc:
      source #{opt_pkgshare}/git-extras-completion.zsh
    EOS
  end

  test do
    system "git", "init"
    assert_match(/#{testpath}/, shell_output("#{bin}/git-root"))
  end
end

__END__
diff --git a/bin/git-extras b/bin/git-extras
index e49cd24..4ae28b5 100755
--- a/bin/git-extras
+++ b/bin/git-extras
@@ -4,13 +4,12 @@ VERSION="4.3.0"
 INSTALL_SCRIPT="https://raw.githubusercontent.com/tj/git-extras/master/install.sh"

 update() {
-  local bin="$(which git-extras)"
-  local prefix=${bin%/*/*}
-  local orig=$PWD
-
-  curl -s $INSTALL_SCRIPT | PREFIX="$prefix" bash /dev/stdin \
-    && cd "$orig" \
-    && echo "... updated git-extras $VERSION -> $(git extras --version)"
+  echo "This git-extras installation is managed by Homebrew."
+  echo "If you'd like to update git-extras, run the following:"
+  echo
+  echo "  brew upgrade git-extras"
+  echo
+  return 1
 }

 updateForWindows() {
