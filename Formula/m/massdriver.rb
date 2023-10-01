class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.0.tar.gz"
  sha256 "280c3bcba7c9521ee61785316509453e9dbe427b7c542de74b5023604c187951"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29c7fe3a8082d081fecad0ca2e107436672f2131e09415ac564cb7f72b2b087d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2fbdbfbbf98a1b443210363834ba546f8f98eeca126f1460199c63adf449082"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9defced56226e1fed968a4c6499d0bfc792230ba8c0fe25c7897962710a28e28"
    sha256 cellar: :any_skip_relocation, ventura:        "136fa270e35e114c3420f01c1a74b7ac4e0f298d2496d685d8de7a868c6e7098"
    sha256 cellar: :any_skip_relocation, monterey:       "16e0e2eb18b614013b542e51d172b12c7a4204b6646332c35e6bf62ff52d8d7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c94bbafa02e3414e1f4570771d9f0920b3a6ba9d5b1efe2d5fb31644c161c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0ca7202b26a4da988ef51c1ac0943deacb27a3428389b08fa32e53a4c909882"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end
