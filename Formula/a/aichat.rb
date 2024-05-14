class Aichat < Formula
  desc "ChatGPT cli"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "113f910315c6fd1bd0746daf346570a26883206d6f61a8a8dd07d98b4c509393"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65aedbca8e93f8c29a90bec2e01d48d42fc058510362333aef279f3728f8f453"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f99293a604f9fc6f9b2872303a4f42fc1aa97b9008372d80bac0812e950b121"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3429018e3206d1af957681697f69e142be47bc70bbe7f3f182cf801ff1ec2a15"
    sha256 cellar: :any_skip_relocation, sonoma:         "576583395d1b05437030519ce547be2c523fc65531eb1db7834998d435c48ea7"
    sha256 cellar: :any_skip_relocation, ventura:        "39cf6939ba0b9f05675b7162cffb6603fc39b8bf07e681f93d08b1412b299ad6"
    sha256 cellar: :any_skip_relocation, monterey:       "e7058d846c7fc4deb2726b5348ee6b90c9be7d893a4ff1f46d58a0cbee7932fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a9be876e0b124cab2f4797210accc7d152d0bfed24db184642d577e1eddfb3e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["AICHAT_CONFIG_DIR"] = testpath

    (testpath/"config.yaml").write <<~EOS
      model: openai:gpt-3.5-turbo

      clients:
      - type: openai
        api_key: sk-xxx
        api_base: https://api.openai.com/v1
        organization_id: org-xxx
    EOS

    output = shell_output("#{bin}/aichat --dry-run math 3.2x4.8")
    assert_match "math 3.2x4.8", output
  end
end
