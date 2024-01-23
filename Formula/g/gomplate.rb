class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/refs/tags/v3.11.7"
  sha256 "037b03858975878d6522c1c4b462f7c8d6352f263dfd8074ba2b965e18cc306d"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "404059120b78c042f4654c9608bb3ba108f61e221ef681de69fed7cef32d07c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc6db82c2479afc923336673bed71de0ebff5c2878ba2b7c85526379a38ce171"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8818eaa30f8ebe99548df4b5c2a8bd19a91b0a4cab289ab2547cffc703a8ef32"
    sha256 cellar: :any_skip_relocation, sonoma:         "10f62a85e5216302b7d8ede3ac1b6c9a5ce81a81a787d251de522b42530b6645"
    sha256 cellar: :any_skip_relocation, ventura:        "262e234f94ffada31682058758be4e42b05b4bcdb9766a4ae5b09cd048b39ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "6d3b73c2b9d5bd8be9569112811193934ad9510c8aeb7b3a6b42b91667b3414f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70ff759ab6815265c5085e59d80ebfafcdf0ab4c13c333aaa4871a4bc021578e"
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

    assert_match expected, pipe_output("#{bin}/gomplate", test_template, 0)
  end
end
