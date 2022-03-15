class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.37.0.tar.gz"
  sha256 "a0bb00caa1eb404b53d6296c81bde917c7ea9b6f50c8c49c1985b95a3dd82002"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03ea4f7d5470e9365d7846349ad89ef8ea34c53561ce0c5d78509aa0d13c7612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64104d910160b34f3abac9a24ca60226b33fe1bcbac3d817301d1bf2c780f32c"
    sha256 cellar: :any_skip_relocation, monterey:       "f861a1fa3f47beb2fa4357eef211ac243455b755bdfd1c09492da0d22db6f3bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd2c27ccb271e18236acf39d23dbef4e00162ac3cb393c7f0a389d68babdd075"
    sha256 cellar: :any_skip_relocation, catalina:       "f35820018b85f4be83a1b9a2b0e1749bad6884d9975c813f71301f1c4eeed495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cff7fd86b987cb83d31eb089095eb522bcda4e937deae58c44397b1c4298664"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
