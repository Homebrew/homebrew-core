class Aichat < Formula
  desc "ChatGPT cli"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "de554ef95d75a17b20f384b5f2ea07b3d2cd6112e87e9e038145d13285633468"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a15f18cc8e96bdf0b5cdc689d76773b795391616a58cdae3c718c391f1d90eae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc503d73c290a56970d1319898306593859e59c2bc757677ff16df8f15e0eb00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa03832342ca7ae4e2d7d34f4af2cac3383ac742ff503c27b57ba6487a1544b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8da708b32223db0a48bc120a14d526af06f523ea5d32b9f97fef69a2f91997fd"
    sha256 cellar: :any_skip_relocation, ventura:        "faa5ba0f2af6e2f13439cbb5531acfa73fb92061bcb85831b601146fc2b31c93"
    sha256 cellar: :any_skip_relocation, monterey:       "05c5efdcadd1688b10c740eaf0f5640548c790267063167e8c808fefe70009c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e80ec8b594e166036703b044f1389ea328ce46bcbf7137494f66cafffa0ad624"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["OPENAI_API_KEY"] = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    output = shell_output("#{bin}/aichat --dry-run math 3.2x4.8")
    assert_match "math 3.2x4.8", output
  end
end
