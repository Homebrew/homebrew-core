class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/releases/download/4.0.0/crowdin-cli.zip"
  sha256 "ecac905279763bfada40b70fe55b0c097df4f38327e8715fc6326692c0245817"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b19b41212f20f9c517123e7741ec126a5c45fa683ae0677c758283c77a0874d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b19b41212f20f9c517123e7741ec126a5c45fa683ae0677c758283c77a0874d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b19b41212f20f9c517123e7741ec126a5c45fa683ae0677c758283c77a0874d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b19b41212f20f9c517123e7741ec126a5c45fa683ae0677c758283c77a0874d"
    sha256 cellar: :any_skip_relocation, ventura:        "1b19b41212f20f9c517123e7741ec126a5c45fa683ae0677c758283c77a0874d"
    sha256 cellar: :any_skip_relocation, monterey:       "1b19b41212f20f9c517123e7741ec126a5c45fa683ae0677c758283c77a0874d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "767084eb6bf6d0fe6e748df225bb2fa7e29ad890e8d86d75d8b716fdc0d14916"
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
