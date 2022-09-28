class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.27.1.tar.gz"
  sha256 "4dd83d68347b895d62ec2749d782a9dbddf314bafef502eac7c5fdcc4058b85d"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1a5d4455857afed164ff6af61cc7f49dd6357e31d0a7d3f7431a26e2bd5ba44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6eab788a9b0900d38650e1fd7c1cf08c6ae329212ef77a4c6e05247534877c41"
    sha256 cellar: :any_skip_relocation, monterey:       "9f81f8c46af5a776d9694248016b20948b2a26294cee32f727a1a7b595205965"
    sha256 cellar: :any_skip_relocation, big_sur:        "9323c7a423763d1c5cd85292a60e92f04ac62a072702b72d6b2260b01f13470c"
    sha256 cellar: :any_skip_relocation, catalina:       "4f189f3c8430cfa9870ad5b8540812f4f0db9a03dd502e64118ebae2625eaf71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aa7716027dca82723eb91370ed770ad77a645867289abcade6d7f51fb0ccb34"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
