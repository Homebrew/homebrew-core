class KafkactlAzure < Formula
  desc "Azure Plugin for kafkactl"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl-plugins/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9fcab4135e68ffba6af40db21ab4c36f798a502be402f6c2d6557d316084b445"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "kafkactl"

  def install
    Dir.chdir("azure") do
      ENV["CGO_ENABLED"] = "0"
      ldflags = %W[
        -s -w
        -X main.Version=v#{version}
        -X main.GitCommit=#{tap.user}
        -X main.BuildTime=#{time.iso8601}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl-azure 2>&1", 1)
  end
end
