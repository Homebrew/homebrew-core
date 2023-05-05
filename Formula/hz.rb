class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "ce119b722b505d7bfbff70e35abdb96152e6c36c8e7944ae166d61158f739ef5"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f629db14297998a117405aad3d5a4ebb0fa53f59d600e882b3a7ba3e2d559b65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f629db14297998a117405aad3d5a4ebb0fa53f59d600e882b3a7ba3e2d559b65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f629db14297998a117405aad3d5a4ebb0fa53f59d600e882b3a7ba3e2d559b65"
    sha256 cellar: :any_skip_relocation, ventura:        "080e13eeebf85b869f8c8a6067a77322c17124621ac68431f1dea683adc57343"
    sha256 cellar: :any_skip_relocation, monterey:       "080e13eeebf85b869f8c8a6067a77322c17124621ac68431f1dea683adc57343"
    sha256 cellar: :any_skip_relocation, big_sur:        "080e13eeebf85b869f8c8a6067a77322c17124621ac68431f1dea683adc57343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "556de483fa7ad43da49a6791b367bc76d590bf5b59572c0875914d8f85f3240c"
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
