class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b0c4b6a8a015387cef962a105e4ce3069e77376df118f25376af89b37c023f2e"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a37835c471ced98d9c920a4e30a4b640130ef996b026fd6144b9a8c1b5b68c72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a37835c471ced98d9c920a4e30a4b640130ef996b026fd6144b9a8c1b5b68c72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a37835c471ced98d9c920a4e30a4b640130ef996b026fd6144b9a8c1b5b68c72"
    sha256 cellar: :any_skip_relocation, sonoma:        "0528425a72c2c5e742396a041aecd015cab7af1c9c620598d216a9458ca18dbd"
    sha256 cellar: :any_skip_relocation, ventura:       "0528425a72c2c5e742396a041aecd015cab7af1c9c620598d216a9458ca18dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d0ce5bbf15880b2c35d31108452ae8a149db04929d97cc2eddb2912fb37edf"
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
