class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "78841d040f59d979d4ba40deddd32fc07644cf14fb1964b7739fdeced6328f2d"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4931fdbdcf3747e22942516490d81fe6b84ec02c336c96d65bb33ffae63ddcdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc95ad0ebdfc96d237c135c8a47603411cf0c85fb0686bfdcfc935b56e6367ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2a7bb952243939481ed24f269bdb8b762a9c11c00884c782dfc8a72d80367ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c80366037593fa77d5477b556c9b4c302f9ec36f9d022046b60a3cf30d911bb"
    sha256 cellar: :any_skip_relocation, ventura:        "475ca65de376900266a0fb847a6530fd084ee7caf1a05021516001b27f35a261"
    sha256 cellar: :any_skip_relocation, monterey:       "f4f31998103b72f175cd0272a0ef06671e2fb8f92998eb06df44111503a0d7dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d95c0c0e944319b6fb5495fb9516b68c6674bcf2047b96372d909d6ea0dac85"
  end

  depends_on "go" => [:build, :test]
  depends_on "thriftgo" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./tool/cmd/kitex"
  end

  test do
    output = shell_output("#{bin}/kitex --version 2>&1")
    assert_match "v#{version}", output

    thriftfile = testpath/"test.thrift"
    thriftfile.write <<~EOS
      namespace go api
      struct Request {
              1: string message
      }
      struct Response {
              1: string message
      }
      service Hello {
          Response echo(1: Request req)
      }
    EOS
    system "#{bin}/kitex", "-module", "test", "test.thrift"
    assert_predicate testpath/"go.mod", :exist?
    refute_predicate (testpath/"go.mod").size, :zero?
    assert_predicate testpath/"kitex_gen"/"api"/"test.go", :exist?
    refute_predicate (testpath/"kitex_gen"/"api"/"test.go").size, :zero?
  end
end
