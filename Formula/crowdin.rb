class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/releases/download/3.10.1/crowdin-cli.zip"
  sha256 "9078bcacbb481eb01fbbfaf6bef87322bb1ca8d6835b543517e913127e0089c4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "174a7c4afc7e11297ae8bed52c03d90dda65dd019b449e3001bb9c04e4743005"
  end

  depends_on "openjdk"

  def install
    libexec.install "crowdin-cli.jar"
    bin.write_jar_script libexec/"crowdin-cli.jar", "crowdin"
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
