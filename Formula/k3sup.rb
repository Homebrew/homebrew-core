class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://github.com/alexellis/k3sup"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.9.7",
      revision: "80383dde517ddaa1db7e56543955143aa99d24bf"
  license "MIT"

  livecheck do
    url "https://github.com/alexellis/k3sup/releases/latest"
    regex(%r{href=.*?/tag/?(\d+(?:\.\d+)+)["' >]}i)
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
