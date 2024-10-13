class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/releases/download/4.2.0/crowdin-cli.zip"
  sha256 "d79f336e0630e053ffbd056c4acf6db7d55c8ac056a519ff0f839188cdb83d86"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cd8d4dc9622b3f89b4abaa5c717a3e183468f5d193426121ed80ac78fe365617"
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

    system bin/"crowdin", "init"

    assert "Failed to collect project info",
      shell_output("#{bin}/crowdin upload sources --config #{testpath}/crowdin.yml 2>&1", 102)
  end
end
