class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "5e96d8e270c063c4cb273c9528afff90ca2b4c0c563e56ceb19fd41685971c76"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8ce90103cd0302ce280ea2ff499da8f6d5dd97cd03a3e9ee9015bb7cdd43a72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "563f976ed35c4259aa01b7acf83b4c8297af455ea222c6aa61b8488902d5f417"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5ca8e318d5c5eccf7f18b93f475b7cebc5f0e5c3ac1a06d9efeaca8c7ee1477"
    sha256 cellar: :any_skip_relocation, sonoma:        "c453de4b7ffc44e5a1446b4155d2f014f22d7aa8fb89fd39c1e934aa972b10e8"
    sha256 cellar: :any_skip_relocation, ventura:       "123ac7a72a8c09edfd31e92489630dfa927cbab602e6d8e9bdb6b9eed031faa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "951f0534ce442ad187ab159720c61d961b236dc70bfd3e3474a54aa4e479a975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d34acfa60f4879e1cfa79fe34b13228be9161fd6dd81c90d14b5b13cd69c016"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/gomplate" => "gomplate"
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
