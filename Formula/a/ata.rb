class Ata < Formula
  desc "ChatGPT in the terminal"
  homepage "https://github.com/rikhuijzer/ata"
  url "https://github.com/rikhuijzer/ata/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "bcf44527769c5d37685f0acaafa1d40ccdb3f3663ba1ae5b5d2e6b7601cc06b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab4d093b95b92ba31c473c7b453280c8e62c34059859b13d7f8fd98d59046675"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b4786a053d334dcd765a3e17230417797e1b5115bbd363d1ff4f9524481ffb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e714105c5a2ec7a527de714d4293c7651f2079b9748f11008f4668a9b11c784f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63a5d9625d26933f4a55c55dea6d63ed62ad5677637f06024e7a84ff09663dba"
    sha256 cellar: :any_skip_relocation, sonoma:         "796b5ee96dd2a1040f1594591b611da027fe75ec9348c4995e39af1c8ea42d76"
    sha256 cellar: :any_skip_relocation, ventura:        "376411fff331be6554e83c3c033ddb5015a37cafa25e5cb2562553338c543811"
    sha256 cellar: :any_skip_relocation, monterey:       "87f3a58a275e3dd6a7323dbb082c697b13bcb7de9cae932b3eed072857dd4885"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb61f5f197eebbaad4518ee4f7a68d3e93b89e486460092008ba52f862a45a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89afa6c333f06af26f722b06e14bce766a39a463c9b1d7888989913da18c3c90"
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
