class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://github.com/asdf-vm"
  url "https://github.com/asdf-vm/asdf/archive/v0.6.2.tar.gz"
  sha256 "5d8c19c311206f5ea4a3a4a978bc5140924d6faf4880dfb7f68cdf1077f036e6"
  head "https://github.com/asdf-vm/asdf.git"

  bottle :unneeded

  depends_on "autoconf"
  depends_on "automake"
  depends_on "coreutils"
  depends_on "libtool"
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "readline"
  depends_on "unixodbc"

  conflicts_with "homeshick",
    :because => "asdf and homeshick both install files in lib/commands"

  patch :DATA

  def install
    cp "completions/asdf.bash", "completions/asdf.zsh"
    bash_completion.install "completions/asdf.bash"
    zsh_completion.install "completions/asdf.zsh" => "_asdf"
    fish_completion.install "completions/asdf.fish"
    prefix.install_metafiles
    prefix.install %w[VERSION defaults help.txt]
    doc.install Dir["docs/*"]
    bin.install Dir["bin/private/*", "bin/*"]
    lib.install Dir["lib/*"]

    inreplace "#{lib}/commands/reshim.sh",
              "exec $(asdf_dir)/bin/private/asdf-exec ",
              "exec $(asdf_dir)/bin/asdf-exec "
  end

  def caveats; <<~EOS
    Add to path:
      export PATH=$HOME/.asdf/shims:$PATH
  EOS
  end

  test do
    output = shell_output("#{bin}/asdf plugin-list 2>&1", 1)
    assert_match "Oohes nooes ~! No plugins installed", output
  end
end

__END__
diff --git a/asdf.sh b/asdf.sh
index ac349c3..03cc1fd 100644
--- a/asdf.sh
+++ b/asdf.sh
@@ -7,7 +7,7 @@ else
 fi

 export ASDF_DIR
-ASDF_DIR="$(dirname "$current_script_path")"
+ASDF_DIR="$(brew --prefix asdf)"
 # shellcheck disable=SC2016
 [ -d "$ASDF_DIR" ] || echo '$ASDF_DIR is not a directory'

diff --git a/bin/asdf b/bin/asdf
index e064320..9a8dbbe 100755
--- a/bin/asdf
+++ b/bin/asdf
@@ -1,45 +1,46 @@
 #!/usr/bin/env bash
+ASDF_DIR=$(brew --prefix asdf)

 # shellcheck source=lib/utils.sh
-source "$(dirname "$(dirname "$0")")/lib/utils.sh"
+source "$ASDF_DIR/lib/utils.sh"

 # shellcheck source=lib/commands/help.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/help.sh"
+source "$ASDF_DIR/lib/commands/help.sh"
 # shellcheck source=lib/commands/update.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/update.sh"
+source "$ASDF_DIR/lib/commands/update.sh"
 # shellcheck source=lib/commands/install.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/install.sh"
+source "$ASDF_DIR/lib/commands/install.sh"
 # shellcheck source=lib/commands/uninstall.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/uninstall.sh"
+source "$ASDF_DIR/lib/commands/uninstall.sh"
 # shellcheck source=lib/commands/current.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/current.sh"
+source "$ASDF_DIR/lib/commands/current.sh"
 # shellcheck source=lib/commands/where.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/where.sh"
+source "$ASDF_DIR/lib/commands/where.sh"
 # shellcheck source=lib/commands/which.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/which.sh"
+source "$ASDF_DIR/lib/commands/which.sh"
 # shellcheck source=lib/commands/version_commands.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/version_commands.sh"
+source "$ASDF_DIR/lib/commands/version_commands.sh"
 # shellcheck source=lib/commands/list.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/list.sh"
+source "$ASDF_DIR/lib/commands/list.sh"
 # shellcheck source=lib/commands/list-all.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/list-all.sh"
+source "$ASDF_DIR/lib/commands/list-all.sh"
 # shellcheck source=lib/commands/reshim.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/reshim.sh"
+source "$ASDF_DIR/lib/commands/reshim.sh"
 # shellcheck source=lib/commands/plugin-add.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/plugin-add.sh"
+source "$ASDF_DIR/lib/commands/plugin-add.sh"
 # shellcheck source=lib/commands/plugin-list.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/plugin-list.sh"
+source "$ASDF_DIR/lib/commands/plugin-list.sh"
 # shellcheck source=lib/commands/plugin-list-all.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/plugin-list-all.sh"
+source "$ASDF_DIR/lib/commands/plugin-list-all.sh"
 # shellcheck source=lib/commands/plugin-update.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/plugin-update.sh"
+source "$ASDF_DIR/lib/commands/plugin-update.sh"
 # shellcheck source=lib/commands/plugin-remove.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/plugin-remove.sh"
+source "$ASDF_DIR/lib/commands/plugin-remove.sh"

 # shellcheck source=lib/commands/plugin-push.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/plugin-push.sh"
+source "$ASDF_DIR/lib/commands/plugin-push.sh"
 # shellcheck source=lib/commands/plugin-test.sh
-source "$(dirname "$(dirname "$0")")/lib/commands/plugin-test.sh"
+source "$ASDF_DIR/lib/commands/plugin-test.sh"

 # shellcheck disable=SC2124
 callback_args="${@:2}"
diff --git a/bin/private/asdf-exec b/bin/private/asdf-exec
index 2da559e..7b4c9d0 100755
--- a/bin/private/asdf-exec
+++ b/bin/private/asdf-exec
@@ -1,7 +1,9 @@
 #!/usr/bin/env bash

+ASDF_DIR=$(brew --prefix asdf)
+
 # shellcheck source=lib/utils.sh
-source "$(dirname "$(dirname "$(dirname "$0")")")/lib/utils.sh"
+source "$ASDF_DIR/lib/utils.sh"

 plugin_name=$1
 executable_path=$2
diff --git a/lib/utils.sh b/lib/utils.sh
index 1b5ca66..fc1c90e 100644
--- a/lib/utils.sh
+++ b/lib/utils.sh
@@ -13,7 +13,7 @@ asdf_dir() {
   if [ -z "$ASDF_DIR" ]; then
     local current_script_path=${BASH_SOURCE[0]}
     export ASDF_DIR
-    ASDF_DIR=$(cd "$(dirname "$(dirname "$current_script_path")")" || exit; pwd)
+    ASDF_DIR=$(brew --prefix asdf || exit; pwd)
   fi

   echo "$ASDF_DIR"

