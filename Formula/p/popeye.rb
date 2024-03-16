class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "1b4bd3e4fe5cb8922cdd1090fb186ec733e27b53c2d3d89abaed0c029bc62a11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bb4fe50d13833c37b187ae1d0b40ee8fd286e3a3ef4bbe9d8809fa438a90fc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1d25028d674caae40154ced55f8c8b17ab5b4f6bc12bbef074815a584644431"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce809a8bfbc21abd740a67aea0ea100c6b58c4053b6679cfb4f6d0680828e4cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "120957be7e06976ac4c71a8e9ba52dee6e62a281d855702a348ae8ffaa2db05c"
    sha256 cellar: :any_skip_relocation, ventura:        "63d525a8741f8b5e8f1356488eff8c2be42857f9c7be77e52ea9f0bc6ed9dc4c"
    sha256 cellar: :any_skip_relocation, monterey:       "0dfd8cbb39077a0ec03b6709d68ef54a171c1fec81738c729546b082236747f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cefe4de42f06724aa1ddb0dd32bed155eaff48fcec0c64325e70fb17e33b0712"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/popeye/cmd.version=#{version}
      -X github.com/derailed/popeye/cmd.commit=#{tap.user}
      -X github.com/derailed/popeye/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    output = shell_output("#{bin}/popeye --save --out html --output-file report.html 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/popeye version")
  end
end
