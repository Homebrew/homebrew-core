class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "4f3e313a9eaaa677d5f69406a62adaf1191daf4901a92729d1a6e8b3be954a2a"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "469f7426de4c5b5f4de93a728fd79a33ceaec11f22381504563b917088d5d3d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0766cfce61b28c5ccfc5c907a566b352373e6a6131475eb01e571bb35c57bc2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef039884459381444e30618ed32c9f3113aa4a2d3e03d5102c100ae42eb3ea28"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "796eb8ef0fdc3d4f14c29d90e4f823d430ff2cbff0134641478d4957989d7bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f105f054060cd1d8a9e5be2935adb7a60c9a32c57557548c1702f0e7df684a74"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/gomplate"
    generate_completions_from_executable(bin/"gomplate", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/gomplate --version")
    assert_equal "gomplate version #{version}", output.chomp

    test_template = <<~EOS
      {{ range ("foo:bar:baz" | strings.SplitN ":" 2) }}{{.}}
      {{end}}
    EOS

    expected = <<~EOS
      foo
      bar:baz
    EOS

    assert_match expected, pipe_output(bin/"gomplate", test_template, 0)
  end
end
