class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.7.3.tar.gz"
  sha256 "08fc913cfe39cf8e70dd5aecdbdb2bd828ec8be0f9dfd9e8650828e6371d22c0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97aa64ddc52dbd53362b995f94d14e93b6e864ca6e43734152a3f013c7340c59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c1e55865967c38924d9dc0d057b327ca50fa3c70506d0cabe8921116778efed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbadf2d9d2dbb90ac7fa489ef87b135c8099d9cc88f273e6841c091cb67e7304"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6b6d999dc7bf84e0f12a708b8a7408eaaf03d78e3b5b6ab6003c5bd598fad76"
    sha256 cellar: :any_skip_relocation, ventura:        "7b14ccabedd80a307cea02cf4c1553bac01d74efb2c5087f1236de15b4eeda6f"
    sha256 cellar: :any_skip_relocation, monterey:       "879a942974fe9e03cb293a3491d5d5a34416af40685e2a4c0173bba4b5b1457c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ef99220b8ac264efabb67963aae9f4a8ad614cdb96b1943a2f22b26da98b367"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
