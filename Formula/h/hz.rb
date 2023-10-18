class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/cmd/hz/v0.7.0.tar.gz"
  sha256 "7719ca66324510b9134b90003d3892e5ef54447859ace01213b9c4b327975ce9"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  livecheck do
    url :stable
    regex(%r{^cmd/hz/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52da6b522723f95c29d3be208340a7ab432c0628262c957de8ac752d17c8cf91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79bbbbd46882bca56a3f00b5c23df38651eae8910320391c9ba58204d44ac320"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f14e5d4db407a7357021a5503d5c1ba4ab01d73957dadfcf4a939a4f17ef770"
    sha256 cellar: :any_skip_relocation, sonoma:         "51a975a5b0261303d5a0a72b5a89a139fb830d99dc3b8349b4bd6f7ea78f4696"
    sha256 cellar: :any_skip_relocation, ventura:        "d3628e519903b72124f2fe23e3ef6c80c21764b935fb510932bf6cb052bece61"
    sha256 cellar: :any_skip_relocation, monterey:       "4e4be8b0d00753734c3aa7e0ea3ab7ebbac968a3ac0d6ae8d006b6b96f304eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34b3b3f19ae69cf2e4c2805753cbf7d7ebec89deb5b830d64dd46966e5dda8da"
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
