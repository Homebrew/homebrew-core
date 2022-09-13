class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.11.3.tar.gz"
  sha256 "4f26895921e52e0515b273659508802676aafa4765cc3751c383b27eb0e9dca1"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c80f158ae60c3b417f11bcb0898809c374230c28184fe57378a9d26f19058cfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8023b9e954959a951837b75c36562399ce387c1b08c0f92d068e1aecde04c6bd"
    sha256 cellar: :any_skip_relocation, monterey:       "d698cce1684e05fc0d0d30c409ba7de132f00eaeb237ced4398b1344d964240f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f266dfe2002bc249a80d38623d61c2bc73ec70fde807f28a15813656aee88d1"
    sha256 cellar: :any_skip_relocation, catalina:       "3d7dda05fcc79abdf48cef37e4ad0144a1ab32f7c64b4f867628c2f2e2ad9386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a1381cb78316e34261ab5ebf575057e90b3ec6fb1744578a9921e214200a18c"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/gomplate" => "gomplate"
    prefix.install_metafiles
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

    assert_match expected, pipe_output("#{bin}/gomplate", test_template, 0)
  end
end
