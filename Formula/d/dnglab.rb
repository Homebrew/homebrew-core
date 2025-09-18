class Dnglab < Formula
  desc "Camera RAW to DNG file format converter"
  homepage "https://github.com/dnglab/dnglab"
  url "https://github.com/dnglab/dnglab/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "dffe4dd94913a687184b2a453eeb170c87afbca62ecf3a4bc680e5f5bf22cacc"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6f8df88f218e2cbe364ece9282ccbca4519ffd7255062701da87be9354c6f59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f88419fd19c10e08b35eccb622ba8737b44eb3cd4f475fe5dc46ae9572ce060f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ceabff3e17c704a0012a939a99c4270771de1d6b76617cf376814b93b2f164c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "156a083c9ebb78650ac6e7433297500c36ed4ad5d9f6c2fa47f6addf5e520942"
    sha256 cellar: :any_skip_relocation, sonoma:        "87090195be4c7ed7b6208ef0ec993811384ddd5672fdd640409d41a653fe5fb9"
    sha256 cellar: :any_skip_relocation, ventura:       "cbf1fee7f7aac51b50b40906c4810bb211927af587b201977af9cc8118197922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6200689f2e64a2442a841db5a2a59e40529d76ac4c7febf240c050e1607999e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "509248fe57abfefa18c941b6fac42e28e5682ac0a31c79c81ddc704a53dbb394"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "bin/dnglab")

    bash_completion.install "bin/dnglab/completions/dnglab.bash"
    fish_completion.install "bin/dnglab/completions/dnglab.fish"
    zsh_completion.install "bin/dnglab/completions/_dnglab"

    man1.install Dir["bin/dnglab/manpages/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnglab --version")

    touch testpath/"not_a_dng.dng"
    output = shell_output("#{bin}/dnglab analyze --raw-checksum not_a_dng.dng 2>&1", 3)
    assert_match "Error: Error: No decoder found, model '', make: '', mode: ''", output
  end
end
