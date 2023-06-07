class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "c568fcafa94168ca10fc6a9bad192d724e3ec3f687200df2e26fc4f1917a28d3"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e0058403c67716dfdcb330b31bb18a820725cb9049706c16d2f16251b02f9a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e0058403c67716dfdcb330b31bb18a820725cb9049706c16d2f16251b02f9a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e0058403c67716dfdcb330b31bb18a820725cb9049706c16d2f16251b02f9a5"
    sha256 cellar: :any_skip_relocation, ventura:        "6806cffa7b8edbe8a9ab27f8d6f19de8fbecef78c9043d17aef48f71137faf67"
    sha256 cellar: :any_skip_relocation, monterey:       "6806cffa7b8edbe8a9ab27f8d6f19de8fbecef78c9043d17aef48f71137faf67"
    sha256 cellar: :any_skip_relocation, big_sur:        "6806cffa7b8edbe8a9ab27f8d6f19de8fbecef78c9043d17aef48f71137faf67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb18224e38f00e37d57e7b296902190db09c6fdaa0ab4c13e9224049232a7a9"
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
