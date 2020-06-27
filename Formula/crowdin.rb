class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/releases/download/3.1.15/crowdin-cli.zip"
  sha256 "391aa2d41b3d2671340e631139a8b8023d75a4933132f19f2f5249fc19e0ea17"

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
    (testpath/"crowdin.yml").write <<~EOS
      "project_id": "12"
      "api_token": "54e01--your-personal-token--2724a"
      "base_path": "."
      "base_url": "https://api.crowdin.com" # https://{organization-name}.crowdin.com

      "preserve_hierarchy": true

      "files": [
        {
          "source" : "/t1/**/*",
          "translation" : "/%two_letters_code%/%original_file_name%"
        }
      ]
    EOS

    assert "Your configuration file looks good",
      shell_output("#{bin}/crowdin lint")

    assert "Failed to authorize in Crowdin",
      shell_output("#{bin}/crowdin upload sources --config #{testpath}/crowdin.yml", 1)
  end
end
