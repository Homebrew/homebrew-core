class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "9d304e04be263cb3fdb83a8ab3cb3b543873a13372d94e700355b16bda4ace46"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "251372f23285015a92e7cd6e38de184b258334773598cd80ee3ba6f8ef546155"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da5bb7ef8219f0ae342f3a7a5a95a5e632f07240d031a8bb9593fa40a1cd41ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5d1314418bfae48069f3732c952caac826022090cc9587b1bdd44954cd8ade6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f75e2303eb5dc47b96617b0ccb52b845dd5d89e2d22c60c2b07dbca47b587e8"
    sha256 cellar: :any_skip_relocation, ventura:        "f77dc68f4f2e07c754515bd481625167732c0bdec18e688473479ad77e26e7ca"
    sha256 cellar: :any_skip_relocation, monterey:       "a32aa4ca4c85de3ac11fa6fdfa4f07a6e3cf9cfcd9c3fd928de62931bfc7dbfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e548198d61b1f5336646ff43bf7f2cd75ed69c288920c5d47d18f3219c40e65"
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
