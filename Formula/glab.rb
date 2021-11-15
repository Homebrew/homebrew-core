class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.21.1.tar.gz"
  sha256 "878c13d064ca6010437de90ca3711962fd87441fcae39bf01cb0af5aa5efd79e"
  license "MIT"
  head "https://github.com/profclems/glab.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f30115f346654210a5580268de26a0a957193e1296d59db442d52b7854738404"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1a989fc60ce6bf9071350d9ce9d48d59858e490d92cb23fed6c979ea3a4dfc8"
    sha256 cellar: :any_skip_relocation, monterey:       "a33a50438b8d38c0ed7da1e040d820652caf79c60177df1755d5ca4d00d7962a"
    sha256 cellar: :any_skip_relocation, big_sur:        "82a903f4d6f4866fa55c93250d63467c8f83003389343cec63e8bc70e0e9dc5e"
    sha256 cellar: :any_skip_relocation, catalina:       "766192bb22eba3e0219aae40b4898d4e0993788154a5885d865ae1e6074ac722"
    sha256 cellar: :any_skip_relocation, mojave:         "60e7f1b0149b2c767b3324bed1719b573db47db3120250c9c596a372a639a06a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c2494a7790d8b3a0391842bc0b70b645a459630a264501becb96d893420768e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    (bash_completion/"glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=bash")
    (zsh_completion/"_glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=zsh")
    (fish_completion/"glab.fish").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=fish")
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
