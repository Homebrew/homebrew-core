class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://github.com/alexellis/k3sup"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.9.11",
      revision: "79720da83b694735d6415f3f3d01f02a1f809da8"
  license "MIT"

  livecheck do
    url "https://github.com/alexellis/k3sup/releases/latest"
    regex(%r{href=.*?/tag/?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e1ef732373e6ff432cf1cd46b467d6b33b18a2acf85663f6d16b215ec4d73823" => :catalina
    sha256 "e939ba24f2bc8b8c4b9d8f79bbf67cc556001ba94b968739ae80f54b46963d54" => :mojave
    sha256 "980e991cd1edf2c7f4e886b7b91f63aef31ff3e5913f90b6850e9f4dc71c412b" => :high_sierra
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
