class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/refs/tags/v3.17.9.tar.gz"
  sha256 "54d2a4a20e52c10a2325c6952355eb91e02ab0720756963d59be43de88ef685d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb70cc746e89ae1dc09722cf0720527cde49decceecbab3a0d80640ef35588c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb70cc746e89ae1dc09722cf0720527cde49decceecbab3a0d80640ef35588c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb70cc746e89ae1dc09722cf0720527cde49decceecbab3a0d80640ef35588c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a3ff2c23bf06e9988309f2f333b23b69b2c96056f020d93a913764139fc4ff1"
    sha256 cellar: :any_skip_relocation, ventura:        "0a3ff2c23bf06e9988309f2f333b23b69b2c96056f020d93a913764139fc4ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "0a3ff2c23bf06e9988309f2f333b23b69b2c96056f020d93a913764139fc4ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fecc819fd62a02b8fc02050d541aead46598d4676311f0c4bdbdd8f454b9514"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
