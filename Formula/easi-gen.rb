class EasiGen < Formula
  desc "Help users to generate code for easier contract interaction"
  homepage "https://github.com/LemonNekoGH/easinteraction-for-cadence"
  url "https://github.com/LemonNekoGH/easinteraction-for-cadence/archive/refs/tags/0.0.2.tar.gz"
  sha256 "be5b17a8f1774ed269e29203701752df57be29bf2eca63e72b68e74a0777521f"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/LemonNekoGH/easinteraction-for-cadence/cmd/easi-gen/main.Version=#{version}"), "./cmd/easi-gen/main.go"
  end

  test do
    # test usage
    system "true"
  end
end
