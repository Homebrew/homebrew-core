class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/cmd/hz/v0.9.1.tar.gz"
  sha256 "0d894328108891d43355c92a7ccb48630fd9c1b9ae8306df81f8ba547ea268ea"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  livecheck do
    url :stable
    regex(%r{^cmd/hz/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "61479a9c40925a86178ac02e323ac67426a2d3125b1e5cefc8758dfaf99b8846"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88684bfd79820cd12a8b0a67703b52e4fac34cebda709b6f0a1c7e09d30104ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72aaef0246a23f5b96d6273de8ecdb1c5f5057baa6a714ffc448d7225d0a4d4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c7e93ea14667b6e3f5b23b2c76ae222dc70700bd8ad61effac10f4194ced37e"
    sha256 cellar: :any_skip_relocation, sonoma:         "28951831c4ff12ad203d486264eddb667a85f0bcc727cab972f7137da0331315"
    sha256 cellar: :any_skip_relocation, ventura:        "fab58df6f5785d57cb1cfb76a1b4802ef55edaddf90a10395a43aa12ef66bfa1"
    sha256 cellar: :any_skip_relocation, monterey:       "94b22308d44a143b1061e3591b8dc4259468f8a9c9a185fd574b9bd681791de3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9788112eb3e8e0bc5251d0884d4d6230b0936969d559747fcc20b062c91dc104"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/hz" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
    bin.install_symlink bin/"hz" => "thrift-gen-hertz"
    bin.install_symlink bin/"hz" => "protoc-gen-hertz"
  end

  test do
    output = shell_output("#{bin}/hz --version 2>&1")
    assert_match "hz version v#{version}", output

    system bin/"hz", "new", "--mod=test"
    assert_predicate testpath/"main.go", :exist?
    refute_predicate (testpath/"main.go").size, :zero?
  end
end
