class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.30.tar.gz"
  sha256 "fb4c48fc8485d51f64af60c96d9d4d68a5a4dfe4ee761b16a3b2159df49050db"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb699e40f84d8aa8135f546614e4dd5d313a3bbf875750419d58c7081e91d9d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e126d675c889cb014d7bcbdecfbf733a9ac94fac3fd7cc2eed3281f63977b62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbd9eeb9c4ae921de4a86319930c712ffb64b3e4d68ce43b7313bd4d6e22d864"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7e4aa22a3f3d0014ca677b5e38c2fc6f2f604408c04cd5d0217c2f441ba1a49"
    sha256 cellar: :any_skip_relocation, ventura:        "131e99cdc9f8e1f02266374c77bf4f37b682a7aa982f08a4ae56bbfa85610d80"
    sha256 cellar: :any_skip_relocation, monterey:       "870a7b46dc76ba914c9413e182ec8c22f0e05a5ceefc14c1e18e34cb5b8855c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7cc8703937fe24eb89ea95241c61361811a290725a4aff772750afb7c462aea"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}/gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end
