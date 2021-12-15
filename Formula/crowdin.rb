class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/releases/download/3.7.3/crowdin-cli.zip"
  sha256 "da83586b70020aa8b5b43c060ba0106e76c2f9c8f1c02a68575f0c6ae500a895"
  license "MIT"

  livecheck do
    url "https://github.com/crowdin/crowdin-cli.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e2f1620439322178744b30253c3bc5204c0bf743c30980bccbd41a39b623b4af"
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
