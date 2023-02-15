class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "2897b91a92c3370a41d9f7d3c8c78a86752ab83d04de77a09a5eb244f1c031dc"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3985d4ce04b677cad940d3d4cf14f04ed7d15da545537227ed444b44efb21cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a254644688369fe87b7123b0eabf6d7dfaef3a239ee400b58819ef2df79c1e78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1bfed1c6fef922ed33b45064ad550590243767229c4bdd448965c62bb518685"
    sha256 cellar: :any_skip_relocation, ventura:        "dac255d5db2a88139e8d13be860c38f8f6efc5cc2fdba79ae85d7ea5c70d7cc2"
    sha256 cellar: :any_skip_relocation, monterey:       "c524e8df43fab5af950c84b5ad97f27d5dab9445dbbfef00832e191f157fca00"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdce069ffc9836e107fed38a79df4f7dce07ec0dcc917c206d39f5e0715af47d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5364891893794213e00a2d73ed4df1ba20ddb8e72d11089dbc724e9747ef6e0"
  end

  depends_on "go" => :build

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "GoFrame CLI Tool v#{version}, https://goframe.org", output
    assert_match "GoFrame Version: cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
