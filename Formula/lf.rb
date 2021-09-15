class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r24.tar.gz"
  sha256 "252e7fda36b874260e78285ddad1e4d8001cc1a40fcc27812ef155bbb10d9855"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e84b1123000a6ee6d7506daa74201c9c4de025d3c1336a2eafde2410ba91b71"
    sha256 cellar: :any_skip_relocation, big_sur:       "b6a81c4d8d6967ee62ef7f39ac1ebbb3e3d47b264a34170e2ea56d1889b221c4"
    sha256 cellar: :any_skip_relocation, catalina:      "75af5a88d7f20472a7bfeddfa3e68a9a227c9c6ffc0345f6e9036f241251f468"
    sha256 cellar: :any_skip_relocation, mojave:        "4d4680e8b3c19a831897ffa9a4e7fdca30cd761f664131f7dc4dc4078b0c8321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "402acd449eedee46b265406ccd255bea59041d02c78c136735a13b48cbca034f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.gVersion=#{version}"
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
