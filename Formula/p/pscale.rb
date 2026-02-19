class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.271.0.tar.gz"
  sha256 "7f45ed831e0f59303b811cca68a06fe6e014e40e1d2fc1ee824b0a4442fa3740"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddc80fbafac01eacfba955c3952df15a8aa9f77ebe6a93c812e8fdd7e982503d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e99461cdd1ce13f0e92488722b218da7ef90c878426ae5d8df52806cb0f17715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84278ca76857c831a8f4b4efbc2b4c5327a824de10e95208659c908f3f71fb68"
    sha256 cellar: :any_skip_relocation, sonoma:        "057f5cf1b1fbf805a6925afc0dfcfb468b950c4ca7e6781b0531955c8c5841a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd93f625678f92be96d13c13de4506be2aa585c93dd36d462102cb016c6a19e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc1314d561c967ee8c95178d6d8683385a39dc3c15f3521befa9875ec9cdd7e6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
