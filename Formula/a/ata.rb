class Ata < Formula
  desc "ChatGPT in the terminal"
  homepage "https://github.com/transformrs/ata"
  url "https://github.com/transformrs/ata/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "a70498492fce7b46a2a62175886a801f61f9f530c5c6d01b664af2750d3af555"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "61e1c7235e1db8bd6b2dca88f24e1dce32658c60817c274a8a3a74f8e93865f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e4e98e4c055e41cc706441024e03f621e29598cf9889dd8735542dea055a34e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f61ec72f7a185910b29a9209a746cd3ab5b951bc114479692fbe59a679292ac7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cca453b1df61a1bfb7c6e4121c6f2885b3558907c8275f871e79a252cee4582d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26a3a3e71ffed54d77329208d9c74ae3eb9be88f5e69cf7fca46f8254aa1ad67"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b2e8e207ef02ff40ecafaed7d1009785ef20473b7b7d89adfac06b0c97b86a8"
    sha256 cellar: :any_skip_relocation, ventura:        "0308bfe2e109b9b02c7a7c4216c741b69a5d485f96fe723da1265eec10651e0c"
    sha256 cellar: :any_skip_relocation, monterey:       "1c08731f02edf7f158c4d8865e331ebea4f91d8699f8fa4c714118af377deb2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ea43319e201b4677ae3e9646b0cd8e7b5ccf1f09a5b5db4f5f92f467301e7d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c73e91e7b7fc1ef0ca0db0c57df4e099c105c1a3f63b95a41a526043bd814ff9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ata")
  end

  test do
    system bin/"ata", "--version"

    config_file = testpath/"config/ata.toml"
    config_file.write <<~TOML
      api_key = "<YOUR SECRET API KEY>"
      model = "gpt-3.5-turbo"
      max_tokens = 2048
      temperature = 0.8
    TOML

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
