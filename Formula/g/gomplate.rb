class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/refs/tags/v3.11.7.tar.gz"
  sha256 "1cae3270759babb959564b74f7e2538992751ca73f74c33f838c50168ac7caf3"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba33ec921a90f54fc478af7ecf3097e3d93051b1eaa46ec0683ea827fa30c0c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0212ffe780a1f0f19a18936d0107c759dc44599b24bc1d97b8aad2dd749ebf75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25a39ea3d7fa2c3c4bc0d2cc6a09f0e59ba69afaf396cffde01e5340c279fb29"
    sha256 cellar: :any_skip_relocation, sonoma:         "618cd848168cd1bf22727ff1657a75d25cc12f6dcb3f36b02861da8caab10467"
    sha256 cellar: :any_skip_relocation, ventura:        "9ae31826c711d5402e16839ab81a833a427a12c3ab8de24e64c98135ed0181d0"
    sha256 cellar: :any_skip_relocation, monterey:       "12e6be93ef029f29a6bd71e3eb94bed36427a84a651313f845232259125c6fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80c90dadba5ca3fc3cfcdad94177d6ef50b328adb7ec4ac7b9c38df69fdfd47a"
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
