class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.4",
      revision: "9ba4228629fb0dfa96dd2a05bf1b9db111bdddff"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c3a793196819073a41f078cf8ab0465b939b4d036e053c7b4ff1855995bacd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3618af175e045b3b73155235150b0038c48b6945f4a9b00f741d950a31a9ae52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5990c63257ff11ea9ae504e312152da985203946a8bcc2ec717101971bac98d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c19db8a5ba0c5180402a869e001ddbf4cbe597129d51a6343caa564066539c9"
    sha256 cellar: :any_skip_relocation, ventura:        "cacd8acb1d76b715f288ce5b6a11da6b2cce5d855690fd8794bac70b072afc80"
    sha256 cellar: :any_skip_relocation, monterey:       "3d71744252ee0084f2349c5e2051d4295a3fdef8f1f1a290b64d051a1290cba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a63046acccfc3be3230c6e45223da7e4f81610f23e9fb2d4e247bd8dbbe97719"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k3sup", "completion")
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
