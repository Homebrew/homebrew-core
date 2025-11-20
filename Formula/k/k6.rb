class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "a2f5ccf6ca7be527cf510d7b1ef7d7b45a2f487023ded0f3bfc88cf8dbf1cbdb"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83e6abf68d1af76fea511f61e81192d8261e52cbea84d65aa594e43eda2fc02a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83e6abf68d1af76fea511f61e81192d8261e52cbea84d65aa594e43eda2fc02a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83e6abf68d1af76fea511f61e81192d8261e52cbea84d65aa594e43eda2fc02a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa26e45994686b53496724a7c1936f2c2c22e803e168fcf43b3e02221b6fe718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "781261c06ab7e7fbefb71c4450765b4ba87829132d3055b96f4a2c8a9e6f2c8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9420c03ec972594d292ef6f17ab1f7f766a7514dfeb56044d9ddab7b7145a11"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
