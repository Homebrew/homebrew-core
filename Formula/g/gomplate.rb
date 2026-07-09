class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "b6763aaf2c52a2e57a02f5e4cae199166b1ae8df8beb43ef5c927bb10ca775fc"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1e6fcfbc4df69b0781db938897865c4d19fc6f041942ef46d926e25a86f3dad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6e4d1a76818d726400dda71d3248b33a2fa2507840fd9affa0800dfdf0b258a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a66df46aa8bb55ff8cf299d12d6a1c2733045c00e795040e08ae0c82310053ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "51c0787636be3f1aab43e33edbaf3b35fb34989e23d4e85543f27cf579b08a28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da27c139a5761775a12ac41373a4bc93eb3202a90d13aef508f1c8b07b225bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad43e2fad7f5fe507982997695fd73e2670f6af865c6d2aa1c940b7b42c3cbfb"
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
