class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.13.2.tar.gz"
  sha256 "8734636fe0a9c395c9a688aaf3f3b441e8e37e0fe23ff05f9099ad3f6b872ae3"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "625426a2003bfce8fcace74794af92ff115f3d0df47b08f628f1e428d83172bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c5cfd440959aed9f2e3bd6d4abf13af5f3b3d18472c3f86057473bfb114e392"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1620f8d845c6258dcf6781b50daa52a7214fbf448b2c258e1192a1099b837177"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc1b29b70d66fbbb578c4808c38704c789476baa8c8fc3472a90cafdf8d5a70d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ce4c1ea594604032c49e1ed47556ab9d8402cef9064c0a6065d4e1244a60141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb5a8f5c60f7a35cbb39229e7e2164c1c06728c4845d55caaafd3a22f65595c"
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
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert_match "valid for (mins):  5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
