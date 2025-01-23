class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/0.10.1.tar.gz"
  sha256 "bcf3c97da8f61febcf6d239e57d156c8593e76fdd28bd39dd7f2efe19148b8b2"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "39b29f3d525559adde5e8560bc3218de78900a1a0d7bc2db01a7759f631c4953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b92a5355efbd2150e97340df0a8e51d18585bb33339a9d80d150985b8d28ee60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77f912f81252725e4fa18d6c7e7439192e17561b2f11990db1ef08ff1344f673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6289f50c1a0e902802f5bd62df73186722456b640593108c77f6e934a5143835"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51dc8f2ea1052d6fe9c0308ce7aa47e20879b071d37db6e4c3165a38f07f197b"
    sha256 cellar: :any_skip_relocation, sonoma:         "599b9b0af904ea0f9449fbb30d162622da1c8055ad2d8c2e1488653c215cf279"
    sha256 cellar: :any_skip_relocation, ventura:        "8fab4867017f6b121a4ac5e66d593111b50d638ce11b11772a498846a26b2866"
    sha256 cellar: :any_skip_relocation, monterey:       "5296c98082cc77718b35eb86c9bf136aae3f0bf3af7845e9e043e3b8f91bbdb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6418e931f4f0ff9563c7e3992697a8682bddefa92203fd15af12be1906176acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7271bdcccfaa6d1f88b5270bb06b0c3c41e2631fa21ccaeed5264cea2cc1ab63"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.branch=master
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")
    # CI runs in a Docker container, so the test does not run as expected.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
