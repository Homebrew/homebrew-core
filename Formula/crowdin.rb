class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://downloads.crowdin.com/cli/v2/crowdin-cli-2.0.29.zip"
  sha256 "5fa69facda79a5c9f70018c86de5467edd2fcaf0154da92d59d4f63003cc7af0"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "crowdin-cli.jar"
    bin.write_jar_script libexec/"crowdin-cli.jar", "crowdin"
  end

  test do
    generate_output = shell_output("#{bin}/crowdin generate").chomp
    assert_predicate testpath/"crowdin.yml", :exist?
    assert_match /^Generates Crowdin CLI configuration skeleton .*crowdin\.yml\'- OK$/, generate_output
    lint_output = shell_output("#{bin}/crowdin lint").split("\n")
    lint_output.each do |line|
      assert_match /^Project [^ ]+ is empty$/, line
    end
  end
end
