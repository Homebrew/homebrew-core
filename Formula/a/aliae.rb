class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://github.com/jandedobbeleer/aliae/archive/refs/tags/v0.26.6.tar.gz"
  sha256 "905602b3dd56b6caf099970132edf7e3366b3ef0d98a71b277e23c00990e979d"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d53160d4849356a90a2678dbf28084f59adb0500f7e9afd84878f5f70bd05ec5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98d44f2dca6d2b36d623e1b32c314020a7df181556e35b2e958929bd949c500c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e673fd81753e7e90ea1e6869fe8df79d44030cd4df7fa5081b46c05c73977bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2232257f5cb03001eaba175dc4049386f8f93052907e8be1e1563f5635fd2089"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "749bcd42aad96e35d801f5eb1b732c58d2fd5f6e4dc521fbd2459384bde14a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d640083863cad4b03db8646421e518a9a02e9b599fe2344fad201d226db5499"
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
