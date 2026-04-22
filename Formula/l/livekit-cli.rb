class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.16.2.tar.gz"
  sha256 "8c4893a34d212f7a294923261ff4bd72a2ec2e64caa85278654ef2a833833f28"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bced2823e81a28a6e0862a585f5ae1d90d48866ac497923d1b8cb44e4461623"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72de9dc6e417ed40ce71d40edab24347320d2050b17818b7e833feea141bf1d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60affe947ede662de88a327af4d18a265ff9ed88f894e6862c5299e00886fb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "720c2f74953428ae7143bcae2fdb66e244632ff6dd0a2a27075df9e2a712c392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65c1e235a8dc6275e55fe611d258e8ca0df1c6ad5ea7f220b73622f55cbbc748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d92d91ae64533344cbe663470a6bc2671c8c5600295556fdac70bbab7d9000b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
