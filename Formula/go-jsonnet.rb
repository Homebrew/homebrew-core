class GoJsonnet < Formula
  desc "Go implementation of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/v0.18.0.tar.gz"
  sha256 "369af561550ba8cff5dd7dd08a771805a38d795da3285221012cf3a2933b363e"
  license "Apache-2.0"
  head "https://github.com/google/go-jsonnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c0d56b389893d87a8358a31775561c373cd117a311ee9f64bbc5988c8d91dd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09a74a4df5e13d87696fd6c610d8e999e7edeee71de24f1ec4f537b53d156bf6"
    sha256 cellar: :any_skip_relocation, monterey:       "420b6afe22b881a4383719795bb4691c07da03d4b116a3c02b99bea1117cad24"
    sha256 cellar: :any_skip_relocation, big_sur:        "855113843b02eaa3569e714f14bdfccc3adc98cb53b29aac76b713ef946fc04c"
    sha256 cellar: :any_skip_relocation, catalina:       "71bacab1628ec14c8cd732fcb6f4bb3ace3acf73b10a8169fca0aeccd524c08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dcfab621b2f70e5411635f841346ac28ce59328ac0508d775d4b394970effe9"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  conflicts_with "jsonnet", because: "both install binaries with the same name"

  def install
    system "go", "build", "-o", bin/"jsonnet", "./cmd/jsonnet"
    system "go", "build", "-o", bin/"jsonnetfmt", "./cmd/jsonnetfmt"
    system "go", "build", "-o", bin/"jsonnet-lint", "./cmd/jsonnet-lint"
    system "go", "build", "-o", bin/"jsonnet-deps", "./cmd/jsonnet-deps"
  end

  test do
    (testpath/"example.jsonnet").write <<~EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = {
      "person1" => {
        "name"    => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name"    => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
