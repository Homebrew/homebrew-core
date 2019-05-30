class Modsman < Formula
  desc "Minecraft mod manager for the command-line"
  homepage "https://gitlab.com/sargunv-mc-mods/modsman"

  # for new versions, update the url's build number and artifact name, the sha256, and the version
  url "https://dev.azure.com/sargunvohra/modsman/_apis/build/builds/37/artifacts?artifactName=modsman-cli-0.20.1&api-version=5.0&%24format=zip"
  version "0.20.1"
  sha256 "136609552bbddbe3dbbd64c6a7731e8ff7cb8fcf8b92532172142f3b0d3d9da2"
  
  head "https://gitlab.com/sargunv-mc-mods/modsman.git"

  depends_on :java => "11+"

  def install
    if build.head?
      system "./gradlew", ":modsman-cli:installDist"
      libexec.install Dir["modsman-cli/build/install/modsman-cli/*"]
    else
      libexec.install %w[bin lib]
      chmod "+x", "#{libexec}/bin/modsman-cli"
    end

    rm_f Dir["#{libexec}/bin/*.bat"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".modlist.json").write('{"config": {"game_version": "1.14"}, "mods": []}')
    system bin/"modsman-cli", "list"
  end
end
