class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r28.tar.gz"
  sha256 "0ccfd2a024a3718d53ec1ed2470053b81bf824fa8b7e824d3b96eb796fc73ab6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cda7c02240372c9dc1ec557ddc7697e2d52a57c1cb0a9f68939319108704398e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbf99ef4ca16892a5d1bea8256753741bd9ce3d10389d174c74c5ac4798cae1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4af3d42dec01b1e7e1436a503a7128f3dcf48ea3ade217c7a3a7cc44409be60"
    sha256 cellar: :any_skip_relocation, ventura:        "13bec1d9d121ddcbd7126c7607adccec7de0964535bedc7a22d7a6eb34c8438a"
    sha256 cellar: :any_skip_relocation, monterey:       "c65cf76057fc99aeed25018c9ff48971e166a7ac1f02d954b10b2265624a53d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8d8a95376dac73ebcaa66bd6f494055e22e49efe2e7c395c4b1160b9c94815d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9682ef70e5247033cbc0d9dec3509252a5599e700160b278aac9c01389213c7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
