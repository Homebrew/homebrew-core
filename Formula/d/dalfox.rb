class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "3eef38f0767c6016cc986a446f5478bc55f7e168e9550b97f53f21729178d759"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7b54610e8ecf804a14d063efc7218a6f4cecf78bb3be4041d9e9dd9f380f25a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a99361b244b15e6eb0b1112a639916830a04ef8b0e14f7ba113582f4b5491f10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef20f79a86b55fcca0b55070ea9c509d9f363f88be93b82ffc820c270536a89e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5784c9fb20f4d7131970ed469f2cacb43619b61bbf0af2ec22e66fb4aea15765"
    sha256 cellar: :any_skip_relocation, ventura:        "2a412d7279b39a963e83cf5ebfe812886faeff539516b37f43b720c21eaaa818"
    sha256 cellar: :any_skip_relocation, monterey:       "a030c6c3561987278a18019be2842884acd32b8d44ff6c61339460cad3651a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4382dcc03055ac285bd422fc1ac855079a13a023a2345ebceb39d910d03ab47a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"dalfox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox version 2>&1")

    url = "http://testphp.vulnweb.com/listproducts.php?cat=123&artist=123&asdf=ff"
    output = shell_output("#{bin}/dalfox url #{url}")
    assert_match "[POC][G][GET][BUILTIN]", output
  end
end
