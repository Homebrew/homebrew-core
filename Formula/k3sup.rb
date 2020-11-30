class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://github.com/alexellis/k3sup"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.9.12",
      revision: "7fb6fdf0b4dfba45b1a11f93b8d10bca0f1698b5"
  license "MIT"

  livecheck do
    url "https://github.com/alexellis/k3sup/releases/latest"
    regex(%r{href=.*?/tag/?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6df88df2574b433ef89aac8b83703d4e8ba1519c057e28211a6186ea321cd1de" => :big_sur
    sha256 "3a851fb2cc522fd85bda7b3377d0c0030bc4655c398aa72e11e09e646bdf9807" => :catalina
    sha256 "221c9665f69b80d0e6c82bf6d00beadf1469c575b9e541fbf7642ca9c9791afc" => :mojave
    sha256 "55d8edb0f9b24eebb2c4639fb3bfcc1e800c7a03319106cae8a81ec27057ccfc" => :high_sierra
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
