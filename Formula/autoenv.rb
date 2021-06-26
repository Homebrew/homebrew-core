class Autoenv < Formula
  desc "Per-project, per-directory shell environments"
  homepage "https://github.com/kennethreitz/autoenv"
  url "https://github.com/kennethreitz/autoenv/archive/v0.2.1.tar.gz"
  sha256 "d10ee4d916a11a664453e60864294fec221c353f8ad798aa0aa6a2d2c5d5b318"
  license "MIT"
  head "https://github.com/kennethreitz/autoenv.git"

  patch :DATA

  def install
    prefix.install "activate.sh"
  end

  def caveats
    <<~EOS
      To finish the installation, source activate.sh in your shell:
        source #{opt_prefix}/activate.sh
    EOS
  end

  test do
    (testpath/"test/.env").write "echo it works\n"
    testcmd = "yes | bash -c '. #{prefix}/activate.sh; autoenv_cd test'"
    assert_match "it works", shell_output(testcmd)
  end
end

__END__
diff --git a/activate.sh b/activate.sh
index 05e908c..091e915 100755
--- a/activate.sh
+++ b/activate.sh
@@ -28,6 +28,7 @@ ${_file}"
 				fi
 			fi
 			[ "$(pwd -P)" = "${_mountpoint}" ] && break
+			[ "$(pwd -P)" = "/" ] && break
 			command -v chdir >/dev/null 2>&1 && \chdir "$(pwd -P)/.." || builtin cd "$(pwd -P)/.."
 		done
 	`"
