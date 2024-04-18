class HiramuCli < Formula
 
    desc "A cli that interacts with large language models, specifically AWS Bedrock Anthropic's Claude models (Haiku, Sonnet and Opus), to generate text based on prompts."
    version "v0.1.14"
    homepage "https://github.com/raphaelmansuy/hiramu-cli"
    url "https://github.com/raphaelmansuy/hiramu-cli/archive/v#{version}.tar.gz"
    sha256 "06dd130228cb5f7798b2c3344bf5b1e1b1df5daa40f5893bb4a79c015f8ab55c"
    license "Apache-2.0"
  
    depends_on "rust" => :build
  
    def install
        system "cargo", "install", *std_cargo_args
        generate_completions_from_executable(bin/"hiramu-cli", "completions")
      end
  

  end