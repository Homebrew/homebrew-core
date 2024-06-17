class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/cmd/hz/v0.9.0.tar.gz"
  sha256 "23577d9453939104d8290c40e151c25dcbaa3dd9b3fcc9bb5611da0744161fb5"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  livecheck do
    url :stable
    regex(%r{^cmd/hz/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dd7b59b28ebdfeb6ea86155f5571306dfb88fe6e725512df383ff81bccd26bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a424ad94e9834bbd01617d5dc7e7dad21ccfd5b26abf67c8b024d566f2f66f7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af141847768ca7c316805d3f65f4c2cae799b9825bda05c96bbbb32c4b16cbfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cfb8c896ef52bd30282df2d48ce103619a4b71975ae883431967728f5124a00"
    sha256 cellar: :any_skip_relocation, ventura:        "005c0fb31288e36e17441f2e5ed41e190212a43487564d96c92f3192f1531cef"
    sha256 cellar: :any_skip_relocation, monterey:       "77788242946a6e0ec7fdfde946774d5db2381882bb2955aa3667dadc0cb6abc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e76d68be4ec25df31528cfa36bb45adcc0bbce09c4a0c6c14aafe4cc93fc2d"
  end

  depends_on "go" => [:build, :test]

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
