class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/releases/download/3.19.3/crowdin-cli.zip"
  sha256 "f5282106bfafc97af307eceaf89d2144c548a26e266f8c74c414aa4b812a8553"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b09a270346f2f5f621f9ce6bfc0f5045057345ef618d74ba8cfdd140dc6ecd30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "706d3db910f6ef9f5067d162aab13e0cc2ff9687636c426fdffbe2629e57d2f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2182365274ee1a630fdbebc5cb1029c86124dcce33c44d6e8994de226a7db0b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f89cd5399fb5325d2339c32ee74e610c4af8cf7d4011caf0737e2536b0e690e"
    sha256 cellar: :any_skip_relocation, ventura:        "f037f4da33280728f5217a078593f6bbb9ef1ca0243a10e76e6b6811d43aa749"
    sha256 cellar: :any_skip_relocation, monterey:       "bd25dc467c74354a66a38c9ca9c640836064829b27738d4b56a1f916f1328a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cc8afc7b73037da14ce835dcd99b578540ca29ad458710841a93db0d520f0a9"
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
