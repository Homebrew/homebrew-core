class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/cmd/hz/v0.6.4.tar.gz"
  sha256 "2ed4d702c7ac53ca200abfb747c64067a723a930a846c12ca0a2fb6fb69c65ce"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  livecheck do
    url :stable
    regex(%r{^cmd/hz/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a6558d02e96fd6a5c275c494327dda70b0145b81c196ad2b3bcc050e3e98701"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a6558d02e96fd6a5c275c494327dda70b0145b81c196ad2b3bcc050e3e98701"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a6558d02e96fd6a5c275c494327dda70b0145b81c196ad2b3bcc050e3e98701"
    sha256 cellar: :any_skip_relocation, ventura:        "44d8436feb8e8290843f0c88d82fdf719a61c9ca2806e5244ad65febf34e87eb"
    sha256 cellar: :any_skip_relocation, monterey:       "44d8436feb8e8290843f0c88d82fdf719a61c9ca2806e5244ad65febf34e87eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "44d8436feb8e8290843f0c88d82fdf719a61c9ca2806e5244ad65febf34e87eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea87adbe13b97b87442720dbec964d979ab3abfb3c50815d109fcf9cd58ad1a5"
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
