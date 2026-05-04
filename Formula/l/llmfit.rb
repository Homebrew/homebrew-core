class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.20.crate"
  sha256 "0c44055a35a789ac9e1d47026417f07683f12331b8f9fc88fc2461d72f556298"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23017f443c739123467ce82719bee7b34651fc33640761482a50906193f1cf6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00ccc476c7d6694541bdad25f912cffc57d4ffae4248f620a3f86301d22cca21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ed4e571b7b114cfa69061b4ac3cacc2274a7a64863d05759e73ba2df6b51ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "f94ba0240b6c79509e213c1c8741c643647bb87744d8ed0e812f43f0816c6440"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f3ef4b6be19b1bfaf161a77ffd2a055c527931298717623dd9c71c73130f74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e97ed4e409dc0da07cc3642168a84315580ff7a57bca73715a9e9ab6cc5a719a"
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
