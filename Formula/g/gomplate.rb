class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "fb08872f54f776863a30adcd58dce0437529d0e6a468839d107803bbff1d0b23"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dae55e481fddcb3061a57c06a811cb96e19d834fbfb266a771aa405770b0e848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b9a43e55f2cd1262f4a88e382c60995cc592bcd02a9b186593e2d2d2fac6dbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66c78605986e1e271d4d3bdbfd5751a26f7d5c3451d108cd8597ae51f529534a"
    sha256 cellar: :any_skip_relocation, sonoma:        "86e3848d04ccab8b7bbb8ff4f06caa0db4095ad6db9af9c7af8c27b8b25833bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f838a801831f98711045834053845c247dcf96760b75f4e366e2cf8d0949a322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ea170a4986806c104a4f7151c3253f16bc46a812a5ea6c1d75389377ddcb8e2"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/gomplate" => "gomplate"
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
