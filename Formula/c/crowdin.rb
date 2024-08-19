class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/releases/download/4.1.1/crowdin-cli.zip"
  sha256 "129446127f9cb5e16de2d9fbd1bc9c22b2088e4f9950eda7e522b5e0773642ad"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c1fd43e8a5b439262c0e32e0247c814a3dff85ba34a4f684fb3fb52cefd2f1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c1fd43e8a5b439262c0e32e0247c814a3dff85ba34a4f684fb3fb52cefd2f1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c1fd43e8a5b439262c0e32e0247c814a3dff85ba34a4f684fb3fb52cefd2f1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c1fd43e8a5b439262c0e32e0247c814a3dff85ba34a4f684fb3fb52cefd2f1d"
    sha256 cellar: :any_skip_relocation, ventura:        "4c1fd43e8a5b439262c0e32e0247c814a3dff85ba34a4f684fb3fb52cefd2f1d"
    sha256 cellar: :any_skip_relocation, monterey:       "4c1fd43e8a5b439262c0e32e0247c814a3dff85ba34a4f684fb3fb52cefd2f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6f011ecfcdbc0e3e02477208447de2f08248628ee190ea85b4c549197602e53"
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
