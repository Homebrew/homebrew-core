class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.40.0.tar.gz"
  sha256 "d3e00387c6dda4e53b3816175b8772db53124198d8ceb499c9a1f6b76092df83"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47f0c1b69f871ab3846b66aeacb39d4b2616fb1e878977bfd9e3e55e42e7532e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38e430746ea4bd6f6eba269cb257167f78f46db6194ec14db842072bd28a388a"
    sha256 cellar: :any_skip_relocation, monterey:       "3af454e58bae786602cff06de36e4d0aec8e45732c5eb3e6b41e75d8c8aa7a2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b7acf53a5f3ef6f787219ac3a35563a69006cd4e82106a8d101dd3f3d3107e5"
    sha256 cellar: :any_skip_relocation, catalina:       "692ade4b20a0037fde9e1b558442e95b6a3ba004e84534fc5ce88182445b82d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ba17e1913da7f0b9d2f70ea292b197a742754e3d0269b5dce151c4f7cd75ec8"
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
