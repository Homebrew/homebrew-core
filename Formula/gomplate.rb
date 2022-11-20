class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.11.3.tar.gz"
  sha256 "4f26895921e52e0515b273659508802676aafa4765cc3751c383b27eb0e9dca1"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8890dc7468a058943c8c3a386dedc24fed14d846ac3869ce482b5761da228f5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7422e0c33f8344f90aaf7143ab3f9efb14765e1f224cc483668625a9c543dc03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25361aea3bacfacd8e865b8187d961423172e995bac7bbcd1decc92a1aebe9a8"
    sha256 cellar: :any_skip_relocation, ventura:        "f447696df84656adee848c3203a2de6e4c01a62ed11495f36b5d2bdf1b5db7e1"
    sha256 cellar: :any_skip_relocation, monterey:       "efd2b06c6aa0f8afc726a9972ed3fd1a27d82a52d0bfae4cc9452ca1164ad537"
    sha256 cellar: :any_skip_relocation, big_sur:        "c65e330ace2baa2b4cd8d84e264a888228317f515847429ca080abefa64fe655"
    sha256 cellar: :any_skip_relocation, catalina:       "5598e94fe9d798ae398770c4acb1ba429784deafbeb309b8c49f4af604ffebbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f44f0319eb88531404a40470c8f3f351c543e328c90fffbf1e89985664ed2a78"
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
