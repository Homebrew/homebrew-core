class Golines < Formula
  desc "Golang formatter that fixes long lines"
  homepage "https://github.com/segmentio/golines"
  url "https://github.com/segmentio/golines/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "d7336fbddb045bd2448629c4b8ef5ab2dc6136e71a795b6fdd596066bc00adc0"
  license "MIT"
  head "https://github.com/segmentio/golines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51f84f0bd25513108f8a8160eaf66abb0c6b74a393dc2edde4af90409096d85a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51f84f0bd25513108f8a8160eaf66abb0c6b74a393dc2edde4af90409096d85a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51f84f0bd25513108f8a8160eaf66abb0c6b74a393dc2edde4af90409096d85a"
    sha256 cellar: :any_skip_relocation, ventura:        "c02d8f38f78fe5916beae3e9bafcfd89c4741300821f795ca1e9edd3d90a67e4"
    sha256 cellar: :any_skip_relocation, monterey:       "c02d8f38f78fe5916beae3e9bafcfd89c4741300821f795ca1e9edd3d90a67e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c02d8f38f78fe5916beae3e9bafcfd89c4741300821f795ca1e9edd3d90a67e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f12a858a458f6b72ec2a6ee0d92de48e258b39dcca9736966af6629e68baa93"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"given.go").write <<~EOS
      package main

      var strings = []string{"foo", "bar", "baz"}
    EOS
    (testpath/"expected.go").write <<~EOS
      package main

      var strings = []string{\n\t"foo",\n\t"bar",\n\t"baz",\n}
    EOS
    assert_equal shell_output("#{bin}/golines --max-len=30 given.go"), (testpath/"expected.go").read
  end
end
