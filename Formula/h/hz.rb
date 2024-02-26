class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/cmd/hz/v0.8.1.tar.gz"
  sha256 "99c64988df9a4bfbd59e694572dbd30bd61d109b3462df8a5db64b2fc2afaf4e"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  livecheck do
    url :stable
    regex(%r{^cmd/hz/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc35af8b84a1ea7d66a2bffe9aa9b3e5cc60f3be79fa38bbb5d49d2fdbd29457"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f276df228f5967fcc8f3d242e2d7447d8d0f31166e0a0a2b27474670690c451e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f09d63b7598d31793b2328d6023c05dd8efd3564db98b2d689d4edc98410ca78"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7194ab95ddffca48544eee564aaed4d4a07dc4a496f11b2d26290ba3ff78c4b"
    sha256 cellar: :any_skip_relocation, ventura:        "f6ee7117178cd2b67d23d71b2b4dd5d4afbb347d9c0e742f2a83d1f641a1c328"
    sha256 cellar: :any_skip_relocation, monterey:       "5eed41e3d3d1443aecf3fca518a79db5d879beee1073d85262245f1ca84b6968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f359f99e4756d54fc1f96058f80e24d687ead5734e32a88aa7f168ca5bd18111"
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
