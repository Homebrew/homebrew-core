class Aichat < Formula
  desc "ChatGPT cli"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "de554ef95d75a17b20f384b5f2ea07b3d2cd6112e87e9e038145d13285633468"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2b79f7719b07f221ffd406048cd7f059a102835ca5c620590fd812015d3d8aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69b6d3ea482e551ded27c57da10d40670f598c4d65daecc3c7de0795caaf3499"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43d601dc5cb9ae5b136967a0f176755e2c1a7d51ae84ac9c3248200fec360b90"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c78c71fc8787f224cf945be12878124862f709cc8c858240554fb08f7bf88c5"
    sha256 cellar: :any_skip_relocation, ventura:        "1fdd8ef112f0da1f38800c667b6010a5335530feb3b02e2bddfb814489e224ad"
    sha256 cellar: :any_skip_relocation, monterey:       "d3dfedaa009129485b0a2722667094ded5ed3a1b0884e1d8a9777d97f6e5d518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94ee38b852e4611d66cfe0756d61e0bacca92b24517b303b14d48a4c26e7ee25"
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
