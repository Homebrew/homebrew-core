class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "77e9e0f004cfbe4e76ef90cbe99b53f3f833c40c1435a02d2fa940db050734d4"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05b9eb7cadcfc53fc874b8c2407aca643a2b1bbf0c572f14cadd437600f20123"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4597ccce1a5fd67ce47d6665a2420db14f9fdf94c8ff1f32da73a2583d564123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fc4b79483397fb1bb121f6fea84d7039f23fe036b465bc56adb5ef011cb2c20"
    sha256 cellar: :any_skip_relocation, sonoma:         "42cca598a7e7485c2decf5fc29deeed7bdcb20b6a05cbb9bc44f60f087b86543"
    sha256 cellar: :any_skip_relocation, ventura:        "ef3ee5b84594e03f1dcfbcc93161d86b1031dbfa8335c8ae4209bc1ace6e19e7"
    sha256 cellar: :any_skip_relocation, monterey:       "f54ee5df6db2c5bb2ca5b0cce935cc5f9086bdef16f4fc0121849eb89de4aa19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "340453f5cbc40dccc7808b796e546fa692b711e765f7810b8b6000818ada612d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
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
