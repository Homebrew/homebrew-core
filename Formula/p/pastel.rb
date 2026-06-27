class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "2903853f24d742fe955edd9bea17947eb8f3f44000a8ac528d16f2ea1e52b78b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/pastel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89d06442647a10897cd8bc0bbe66f4d30ab81783a4621318bf1bacd4fdba2173"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72f9eefc623c703f761ede7bc3788e58af4ef92faefae6afbf546825d33d1e36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c8f2b3d8d4a73b155605cd3afea957b8f8be6cd0a32c70a2e73e9d222825a7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fed916e4b23ebd294469b3f91eba4e4bb15732c91a5a3f90ebb3e0b10071d77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc2150ac3309e6c8bc38cc52447438a45a5ae94b397fa11299887cc017cdc085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d7d99fd7882266f0151351968c4a34ced4697258db1ca0860d5674af052154"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/pastel.bash" => "pastel"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
