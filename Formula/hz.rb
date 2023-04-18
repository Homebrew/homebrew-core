class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "8fcc6ac1e9e5fe0ca5ecf6d516bd0b29f81e0dfb37506149892e59a1e57b92a7"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f28ce4fc4bd399d6bd634da3a71aa29e787979d5a7a4b6b2d12ae9c65523965"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "313ce62d6802f9bf625184a8bbe977654405cdd2f58a25fe3381559c76c7e731"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67fa62984696a7d42a348c258164731ecf578774f7f59220f4de6cbc9b3ec046"
    sha256 cellar: :any_skip_relocation, ventura:        "1776f88d2a4cd210402a00ded828f963361b4e7fe312ed90a22734964acd3b37"
    sha256 cellar: :any_skip_relocation, monterey:       "3740039a6ca7b0cd4e0ad4401c947d05a59f7822bfe49f29f2fa7a476410232b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8aee9ef4517a5c6091590bfe461a503d871515bd8f59533ed32987022ad90fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08fe66c554d6c1a762961fe811fe62ffd967e194880e9de59930dc1d2c0fbabb"
  end

  depends_on "go" => :build

  def install
    cd "cmd/hz" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
    bin.install_symlink "#{bin}/hz" => "thrift-gen-hertz"
    bin.install_symlink "#{bin}/hz" => "protoc-gen-hertz"
  end

  test do
    output = shell_output("#{bin}/hz --version 2>&1")
    assert_match "hz version v#{version}", output

    system "#{bin}/hz", "new", "--mod=test"
    assert_predicate testpath/"main.go", :exist?
    refute_predicate (testpath/"main.go").size, :zero?
  end
end
