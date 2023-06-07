class Ata < Formula
  desc "ChatGPT in the terminal"
  homepage "https://github.com/rikhuijzer/ata"
  url "https://github.com/rikhuijzer/ata/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "6e4a54193f9d875701535f7eaf36225d9b4ec47caf6234827291e6fa6a72951f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82f2ef3c11c86571cb4e08a895b795bb9d19f1cf3cdbb2fef84b067dbfd43722"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e119f0978880f7fb3dcc8e63d1ffe6bce3436c4a765c83514c00b8cbf5543b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43d57f47e36462c7d72941ba8e99773e7be1162476cd5f6faf3850610a21d76e"
    sha256 cellar: :any_skip_relocation, ventura:        "5ab137326fe947e49363db90c9e3b94d8d225fb26f513c8b05d6410b9a99b4af"
    sha256 cellar: :any_skip_relocation, monterey:       "cbe8f7a29c0a362b5409b18ddddda93c954b0ca516cdc32b5dfa12903b0c30bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "85722074ae1fe19d6fa94c622d84e655374d81d24abddb039576161e69adf3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "973861ce14bb918ad580d1a0f833c6864bdb0c75e0a61a46d75bde41168c243c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ata")
  end

  test do
    system "#{bin}/ata", "--version"

    config_file = testpath/"config/ata.toml"
    config_file.write <<~EOS
      api_key = "<YOUR SECRET API KEY>"
      model = "gpt-3.5-turbo"
      max_tokens = 2048
      temperature = 0.8
    EOS

    IO.popen("#{bin}/ata --config #{config_file} 2>&1", "r+") do |pipe|
      assert_match "Ask the Terminal Anything", pipe.gets.chomp
      assert_empty pipe.gets.chomp
      assert_match "model: gpt-3.5-turbo", pipe.gets.chomp
      assert_match "max_tokens: 2048", pipe.gets.chomp
      assert_match "temperature: 0.8", pipe.gets.chomp
      assert_empty pipe.gets.chomp
      assert_match "Prompt: ", pipe.gets.chomp
      pipe.puts "Hello\n"
      pipe.flush
      assert_empty pipe.gets.chomp
      assert_match "Error:", pipe.gets.chomp
    end
  end
end
