class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.5.crate"
  sha256 "370c0def1c879c6cdb41c028834bcaccb399b6403bdefb6875d90d50359e8cb5"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb99f4a4f1e39d8bc10dca7cbccd23b437eecc9e0abcbb8e0dadfd9af7a873fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6597dd89aeaeef4bd1207758540a957c82599a7ae500c1970a0b096addb5559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04d881b3d9feb2c6dc78b64a3025548bb463aa4731996eec72bfc70ea957c204"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb3645e70a652e022c89869bc6287f4433219c648a54bfb332aeeb8a7dc5a9df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "071d0c818404d46be6ba76d517bfc377ab3b87fbf24f00bf18eef4aebc280d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a1198da13394f0015181beeb80f4f25b55989015c7ad8078b9ddd35d0e05b1d"
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
