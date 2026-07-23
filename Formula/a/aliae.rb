class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://github.com/jandedobbeleer/aliae/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "3d20ffd39244e5d630b83cc6d0702276571151e94d03bfbf28b2f86e9aa25ab1"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53be7a204a008a7875692a1f60ac83a3b17e9a7dd3ccfd5ff3b3fc14804cffbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6a102c2852e467e98bc3520d9eca6cd2230c85c6adff0488ff6fa616ba6ce9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8529e51e250ae45fa0f7dd8708a15df65a0bb13360bd4ddfb9acf81ec9b34541"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0acc2f5c56ef2f7cfb989281e045ef064a2eff9724975ee8f1cccf525fd7f1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "216117c124f96c20fd6f370d5a00ea00fd0482df615af4b0dd994bb0424d4874"
    sha256 cellar: :any,                 x86_64_linux:  "2ae42c515e3f67490893a4944fa2407308a25e24bba375af9d1b7a786fb80f9d"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      ldflags = "-s -w -X main.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"aliae", shell_parameter_format: :cobra)
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
