
class BatsCore < Formula
  desc "Bash Automated Testing System"
  homepage "https://github.com/bats-core/bats-core"
  url "https://github.com/bats-core/bats-core/archive/v0.4.0.tar.gz"
  sha256 "e3b65b50a26e3f0c33b5d0a57d74101acf096e39473294d4840635ca6206fec7"

  bottle :unneeded

  def install
    system "./install.sh", prefix
  end

  def caveats; <<~EOS
    bats: bash automated testing system
    bats-core is the continuation of the original bats project.

      IF YOU ALREADY HAVE BATS INSTALLED:
        This version of bats is 0.4.0 via bats-core.

        All versions up to and including 0.4.0 are identical mirrors through
        both bats and bats-core.

        However, to complete installation you may need to unlink, remove,
        or overwrite your older bats installation.

          To unlink:
              brew unlink bats && brew link bats-core

          To overwrite:
              brew link --overwrite bats-core

          To remove:
              brew remove bats && brew link bats-core

    For questions/issues: https://github.com/bats-core/bats-core/issues
    More information can be found at: https://github.com/bats-core/bats-core
    EOS
  end

  test do
    (testpath/"testing.sh").write <<~EOS
      #!/usr/bin/env bats
        @test "addition using bc" {
          result="$(echo 2+2 | bc)"
          [ "$result" -eq 4 ]
        }
    EOS

    chmod 0755, testpath/"testing.sh"
    assert_match "addition", shell_output("./testing.sh")
  end
end
