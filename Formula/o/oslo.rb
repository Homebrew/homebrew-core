class Oslo < Formula
  desc "CLI tool for the OpenSLO spec"
  homepage "https://openslo.com/"
  url "https://github.com/OpenSLO/oslo/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "8e3c501103cbfb0d9980a6ea023def0bdef2fe111a8aec3b106302669d452ec2"
  license "Apache-2.0"
  head "https://github.com/openslo/oslo.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1836a8af35219dad7ccc7356b6fc21582ea7caf647794abcf8e49de38c1aa0d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1836a8af35219dad7ccc7356b6fc21582ea7caf647794abcf8e49de38c1aa0d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1836a8af35219dad7ccc7356b6fc21582ea7caf647794abcf8e49de38c1aa0d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "54e95d65cc8760adaf32a962d23acfb89bceeb6e5c02ca013d3b3892c4bfcd33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24bfddf720e0e388ee1c742d8274a4b9c418f7715a6b770f8214a61fe177f8d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc923992b76b691507a0423c709070cbace601f1fef41ba8217a7d442591e900"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/oslo"

    generate_completions_from_executable(bin/"oslo", shell_parameter_format: :cobra)

    pkgshare.install "test"
  end

  test do
    test_file = pkgshare/"test/inputs/validate/unknown-field.yaml"
    assert_match "json: unknown field", shell_output("#{bin}/oslo validate -f #{test_file} 2>&1", 1)

    output = shell_output("#{bin}/oslo fmt -f #{pkgshare}/test/inputs/fmt/service.yaml")
    assert_equal File.read(pkgshare/"test/outputs/fmt/service.yaml"), output
  end
end
