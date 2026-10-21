class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "57082793307653a7b5189922c0be93da144db281dc478523a480858f6f906985"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86c27eb30e8de6d3e24826df544fc2917215ab656ec6d6e11a937a1cc0e0f388"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8168604167f4210c0664e70a82eca375ee18d8c4e0258e8ea1c085267f1f0a9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "871fbdb8d6a1b77ad428013fab0041c22116f8394197c217f30c0a41bdb49019"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b82c48194473461cbc569dead859e5ef2f00bb293f45590dbde6fe8a9891bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8293576433d3ee4e77212d2d3546a18498a4e2965234945db43ed683641b4932"
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
