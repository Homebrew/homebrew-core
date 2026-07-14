class Oama < Formula
  desc "OAuth credential manager"
  homepage "https://github.com/pdobsan/oama"
  url "https://github.com/pdobsan/oama/archive/refs/tags/0.22.0.tar.gz"
  sha256 "10866f90ec8adf227708fc3abe8d25a7d94c136ee9f5b43e6b91b504bf11e6de"
  license "BSD-3-Clause"
  head "https://github.com/pdobsan/oama.git", branch: "main"

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build
  depends_on "gmp"
  depends_on "gnupg"

  on_linux do
    depends_on "libsecret"
  end

  # Fix Git repository requirement for Homebrew source builds.
  # Remove once upstream merges:
  # - https://github.com/pdobsan/oama/pull/103
  patch :DATA

  def install
    # Pin upstream's intended githash fork to an immutable commit.
    # Remove once upstream merges:
    # - https://github.com/pdobsan/oama/pull/102
    inreplace "cabal.project" do |s|
      s.gsub!(
        %r{^(\s*location:\s*https://github\.com/pdobsan/githash\s*)$}m,
        "\\1\n    tag: d006ec12c4a241b825fc76bd6baec549ff23d4fe",
      )
    end

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    # Fix upstream completions hard-coding /usr/bin/oama (Homebrew installs elsewhere).
    inreplace "completions/oama.bash", "/usr/bin/oama", "oama"
    inreplace "completions/oama.fish", "/usr/bin/oama", "oama"
    inreplace "completions/oama.zsh",  "/usr/bin/oama", "oama"

    bash_completion.install "completions/oama.bash" => "oama"
    fish_completion.install "completions/oama.fish"
    zsh_completion.install "completions/oama.zsh" => "_oama"

    pkgshare.install Dir["configs/*"] if (buildpath/"configs").exist?
  end

  test do
    ENV["HOME"] = testpath
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    ENV["XDG_STATE_HOME"] = testpath/".local/state"

    config = testpath/".config/oama/config.yaml"
    config.dirname.mkpath
    config.write <<~YAML
      encryption:
        tag: KEYRING
      services:
        google:
          client_id: test-client-id
          client_secret: test-client-secret
    YAML

    output = shell_output("#{bin}/oama --config #{config} printenv")
    assert_match "oama_version: #{version}", output
    assert_match "client_id: test-client-id", output
    assert_match "auth_endpoint: https://accounts.google.com/o/oauth2/auth", output
  end
end

__END__
diff --git i/lib/OAMa/CommandLine.hs w/lib/OAMa/CommandLine.hs
index bc4ee02..45de7ea 100644
--- i/lib/OAMa/CommandLine.hs
+++ w/lib/OAMa/CommandLine.hs
@@ -20,21 +20,24 @@ import Options.Applicative
 import Paths_oama (version)
 import Text.Printf
 
-gi :: GitInfo
-gi = $$tGitInfoCwd
+giE :: Either String GitInfo
+giE = $$tGitInfoCwdTry
 
-_GIT_STATUS_INFO :: String
-_GIT_STATUS_INFO =
-  printf
-    "%s %04d.%s%s"
-    ( TF.formatTime
-        TF.defaultTimeLocale
-        "%Y-%m-%d"
-        (TCP.posixSecondsToUTCTime (fromIntegral (giCommitTime gi)))
-    )
-    (giCommitCount gi)
-    (take 8 (giHash gi))
-    (if giDirty gi then " dirty" else "")
+gitStatusInfo :: Maybe String
+gitStatusInfo =
+  either (const Nothing) (Just . fmt) giE
+  where
+    fmt gi =
+      printf
+        "%s %04d.%s%s"
+        ( TF.formatTime
+            TF.defaultTimeLocale
+            "%Y-%m-%d"
+            (TCP.posixSecondsToUTCTime (fromIntegral (giCommitTime gi)))
+        )
+        (giCommitCount gi)
+        (take 8 (giHash gi))
+        (if giDirty gi then " dirty" else "")
 
 data Opts = Opts
   { optConfig :: !String,
@@ -65,7 +68,7 @@ optsParser =
     )
 
 versionInfo :: String
-versionInfo = showVersion version <> printf " - %s" _GIT_STATUS_INFO
+versionInfo = showVersion version <> maybe "" (printf " - %s") gitStatusInfo
 
 versionOption :: Parser (a -> a)
 versionOption = do
