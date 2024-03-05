class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/refs/tags/v3.17.9.tar.gz"
  sha256 "54d2a4a20e52c10a2325c6952355eb91e02ab0720756963d59be43de88ef685d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0c2685a2ebbcaae0f06aba46f3f485d0374989a51134ad285f680407a4304ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0c2685a2ebbcaae0f06aba46f3f485d0374989a51134ad285f680407a4304ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0c2685a2ebbcaae0f06aba46f3f485d0374989a51134ad285f680407a4304ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a7f51f0d9517b018e305f73f46e662cef21301d963b16700f67d585dc445759"
    sha256 cellar: :any_skip_relocation, ventura:        "0a7f51f0d9517b018e305f73f46e662cef21301d963b16700f67d585dc445759"
    sha256 cellar: :any_skip_relocation, monterey:       "0a7f51f0d9517b018e305f73f46e662cef21301d963b16700f67d585dc445759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b52315ee0403c545935bb3654765bca8b1bb5b0a503645a690a3ed160d10664"
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
