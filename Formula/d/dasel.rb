class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "b70b50bb901379c9bd1350bdef436e4cae83089a123ba3225a5fd99dbbc9e5b1"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b228163b237833a2ab5a4f33601de2bbf73bb8a41492a76144b968a457862f85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b228163b237833a2ab5a4f33601de2bbf73bb8a41492a76144b968a457862f85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b228163b237833a2ab5a4f33601de2bbf73bb8a41492a76144b968a457862f85"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b1d4c6fcae8636e5323f0b5b3ffd404d32e91c25531857104b7850f594f0237"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e7eb77bc8851b6280a787e1bb6946c89a12ba9f6a08ea2f3637eca101ebccf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65750c12492d3cbcdbea2423e10009fe6a2dc28c53e52cf624f6c92fbe936ada"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
