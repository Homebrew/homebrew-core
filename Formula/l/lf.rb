class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/refs/tags/r38.tar.gz"
  sha256 "9e5b8baf0af6f131c3f2254ab0454fb4e0dc54ae3e97e23de5153134889b924e"
  license "MIT"
  head "https://github.com/gokcehan/lf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48b3e4e66692e756ea97a19af4dd41449d3841e91f450e530fa3597ea567694f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48b3e4e66692e756ea97a19af4dd41449d3841e91f450e530fa3597ea567694f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48b3e4e66692e756ea97a19af4dd41449d3841e91f450e530fa3597ea567694f"
    sha256 cellar: :any_skip_relocation, sonoma:        "59553d9f91e56998879b86ac919d50788759169cdbded07a7f6b7834339e35ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc0c8ab91b155179d8e5b6e84963bab0062efe65fae3dd4623f911de793667fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")

    man1.install "lf.1"
    bash_completion.install "etc/lf.bash" => "lf"
    fish_completion.install "etc/lf.fish"
    zsh_completion.install "etc/lf.zsh" => "_lf"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
