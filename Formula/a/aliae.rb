class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://github.com/jandedobbeleer/aliae/archive/refs/tags/v0.26.6.tar.gz"
  sha256 "905602b3dd56b6caf099970132edf7e3366b3ef0d98a71b277e23c00990e979d"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23027e091dc14b23943ce0c49bbdd033aa88b284c31873db383174af492b1f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b92e61c0150e736a343ea89b719b2daa761b380e283a07ed186800c96566243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67767bffeda6f91745690be6ad4f36de9095ed20338e4fd51f07b13c1380b053"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c2e3fbd5cbacc683410564241b3af976f0dd7cce4927a01c44bae2617a5085a"
    sha256 cellar: :any_skip_relocation, sonoma:        "80f94a1ed79e0501da37ec491c68eeac725df677a1e4277a6f22a0a9f189798b"
    sha256 cellar: :any_skip_relocation, ventura:       "c2147bc050d3bc14bd1d48a1bd2b9625143179da77c9666260e0dac634c2d1ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73937fe03334e20ce13283b3cca4f9494fa0ff1065238424584e39b553bf3393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4322cff6d3ca1b321177b9f03422de1259caa1f173cd52c099e6e7afa1d696c1"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      ldflags = "-s -w -X main.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"aliae", "completion")
  end

  test do
    (testpath/".aliae.yaml").write <<~YAML
      alias:
        - name: a
          value: aliae
        - name: hello-world
          value: echo "hello world"
          type: function
    YAML

    output = shell_output("#{bin}/aliae init bash")
    assert_equal <<~SHELL.chomp, output
      alias a="aliae"
      hello-world() {
          echo "hello world"
      }
    SHELL

    assert_match version.to_s, shell_output("#{bin}/aliae --version")
  end
end
