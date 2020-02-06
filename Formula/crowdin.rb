class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://downloads.crowdin.com/cli/v2/crowdin-cli-2.0.31.zip"
  sha256 "93defe16706783e92cbe3b32e528e495ddffa9e2a68471c3b70a2eb6c487e245"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "crowdin-cli.jar"
    (bin/"crowdin").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/crowdin-cli.jar" "$@"
    EOS
  end

  test do
    generate_output = shell_output("#{bin}/crowdin generate").chomp
    assert_predicate testpath/"crowdin.yml", :exist?
    assert_match /^Generates Crowdin CLI configuration skeleton .*crowdin\.yml\'- OK$/, generate_output
    lint_output = shell_output("#{bin}/crowdin lint", 1).split("\n")
    lint_output.each do |line|
      assert_match /^Project [^ ]+ is empty$/, line
    end
  end
end
