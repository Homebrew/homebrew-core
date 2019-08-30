class CrowdinAT3 < Formula
  desc "Command-line tool allows you to manage resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://downloads.crowdin.com/cli/v2/crowdin-cli-three-3.0.0.zip"
  sha256 "190b2154e0755f7a286007e5e1ce38cfd57091dda804bd46b3131c175525293e"

  bottle :unneeded

  keg_only :versioned_formula

  depends_on :java => "1.8+"

  def install
    libexec.install "crowdin-cli.jar"
    bin.write_jar_script libexec/"crowdin-cli.jar", "crowdin"
  end

  test do
    generate_output = shell_output("#{bin}/crowdin generate").chomp
    assert_predicate testpath/"crowdin.yml", :exist?
    assert_match /^Generating Crowdin CLI configuration skeleton .*crowdin\.yml\'- OK$/, generate_output
    lint_output = shell_output("#{bin}/crowdin lint", 1).split("\n")
    assert_match /^`Source` parameter is empty$/, lint_output[0]
    assert_match /^`Translation` parameter is empty$/, lint_output[1]
  end
end
