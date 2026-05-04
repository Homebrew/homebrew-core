class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.20.crate"
  sha256 "0c44055a35a789ac9e1d47026417f07683f12331b8f9fc88fc2461d72f556298"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a3badbfdd25f526cfcfd944f861d4cd0f7d0a353afe3930a6b8531d463a8079"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dd93a88d61aa839f9ae0f6a99c74f67cd69f35b3bbfd0e269382245b8ed5c7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc4cf03675bc2dab16b3f3702cfa6f8f535992f7995c0f3b40e286e7f283b567"
    sha256 cellar: :any_skip_relocation, sonoma:        "5596a5f3302edde36a564d6dd7e3910c155f951b0e665cdcf142116f164709fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c39bd96750bac75e5bc4615a36890355f05b14a845954c6b515e17860da2972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98cc32121af2764f59f87f7293b1cf03479d2024a730b1cf0ebd15a6db736c16"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
