class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://github.com/alexellis/k3sup"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.9.12",
      revision: "7fb6fdf0b4dfba45b1a11f93b8d10bca0f1698b5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "04212a4ac9c31a70b936fc22a2e4bb15900e4f5d7888be49e7b9755fc30845ad" => :big_sur
    sha256 "0c202ba3aac77a105211c5ee4c6a1764983d7515a650f8bb8a6949316c2327e1" => :catalina
    sha256 "1c47e9c322eedb5d020543f6f5b3590be80b0407171d4e4008ccca853f8b9079" => :mojave
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp

    system "go", "build", "-ldflags",
            "-s -w -X github.com/alexellis/k3sup/cmd.Version=#{version} -X github.com/alexellis/k3sup/cmd.GitCommit=#{commit}", *std_go_args
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
