class Ata < Formula
  desc "ChatGPT in the terminal"
  homepage "https://github.com/rikhuijzer/ata"
  url "https://github.com/rikhuijzer/ata/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "bcf44527769c5d37685f0acaafa1d40ccdb3f3663ba1ae5b5d2e6b7601cc06b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3f15186014347013c3966beaff07a2b34405393c3b83bc98f369730ecbefc8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11ceda7e1f9b10ddac41d7a0687c44ecf702109e7d443effac424d152d3c9342"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74719c628256c3fd90da8206188aae147f8d3c5a9f5805a10035d6299895afca"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba6080b05708a7bb465976924c1a92248c90e4e82c0a73bccb838b4bff2c46fc"
    sha256 cellar: :any_skip_relocation, ventura:        "08b12fc8128e22b89921d05c9b283b1a1a9eaa42efa23cb5fac3b8f551702500"
    sha256 cellar: :any_skip_relocation, monterey:       "9b911b027fa1e279ecc48d23e14d4595d6a39ce3374d04b06934a93481b4137d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "667fbfb42dfab3ff9ea99a6768f0bdaea3e230249e0b17745563bd9455b4afc1"
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
