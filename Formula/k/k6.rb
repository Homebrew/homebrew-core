class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "a11776d57e9cf3fb306c4f0df9141f972c1b6506c47a750fd71d0f5b24945272"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0cacea6742d566d4567dfcc0cd771942e6fad5073eca2203fc5990e0b16880b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0cacea6742d566d4567dfcc0cd771942e6fad5073eca2203fc5990e0b16880b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0cacea6742d566d4567dfcc0cd771942e6fad5073eca2203fc5990e0b16880b"
    sha256 cellar: :any_skip_relocation, sonoma:        "70606d81b285a05276346d34c4f1f3f0f8a0cbb1c57c449cf955c962c7d17e60"
    sha256 cellar: :any_skip_relocation, ventura:       "70606d81b285a05276346d34c4f1f3f0f8a0cbb1c57c449cf955c962c7d17e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c59c33536818d69e337bd36ce5b3e58054a019260d35027efae3b50ca7b56a5"
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
