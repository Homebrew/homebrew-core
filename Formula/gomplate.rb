class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.11.5.tar.gz"
  sha256 "49d68aef8c0358b5f292444f378bdf40361a71f26ab0292f5468c701367142d8"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f018acf7fd9b2b2339f2ae757ea4368314fab088f1da247f50db6e443245c82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e17a2b3ff906f99841e7af1fe1fe408cd35f6a8293547b88f856393bfba77123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8af25968009c6d42dc1776df3dc5c63a83a2b2cec471da2539a6b43f0903916"
    sha256 cellar: :any_skip_relocation, ventura:        "dc8773b5f4cf4cb8e28a30824273b7468b011de581eec2ebadf7ca1f645e5e71"
    sha256 cellar: :any_skip_relocation, monterey:       "b661975e15ceb6b4fd5560e128cae35190cce686309048e7d629d0b3789d1f4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d592cb70865f8a6ef26b1f8c2dc36263e508983a9a944451f759ff5e49255bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fc73692e6a399c1b5a2d7d138c75e473ab4b7c977d830f7db0f3561911e1cee"
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
