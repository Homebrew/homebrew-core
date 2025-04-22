class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "647d8775f170fb8b8954a76a59c4a23db50b5c1fdd9faf6b51e17737d8b402a5"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3e19ece0a6fc1cecbe9d14e33b16a3fba59d9a4ad92411ac9339c09f0709768"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0324bded45407fa624d39d11477f16329d6c01009a7dbd7f99cefbf4ca87efa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2479a131cad59973db3ef6d51f209a6b4b96f43c1994840d070df949092bf4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e144c054bf5f1caf836126bf820b3e75ca94b3488e53d26503a3d5df902a0f9b"
    sha256 cellar: :any_skip_relocation, ventura:       "ae604e6f7c34798b59fb6077b2f63b5cfb4a4ed7e18ebb27b81799abb6ac5615"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5ebbcf6abc0a970423a408c2708aaa90ac362cdc4acbeb4385cb8134a9ce7a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b400462b3830d910f6760e71238c51f33001685ff10e722cea6844e95da1dc59"
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
