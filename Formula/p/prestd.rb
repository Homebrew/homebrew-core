class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "3b64722b1469858ed54b7c7acc70ebb15085b2b17329b8e6619486d036c544c0"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f9fbae501c630931608bee06bec7566657cf491d0525c7627fcaa7ca91f7dff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e8496084811691045e1162e73f6041ef5337e6bb022d33de4216089ed6163ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b503c054fc7b29b37335b022902cefd2502fec3f9c73f6fbc69ef74b7e699f18"
    sha256 cellar: :any_skip_relocation, sonoma:         "82a58b66c73f8aeccad73cc92cf9e4840cd73b2b2efaa6e0e8d6a253faab83c6"
    sha256 cellar: :any_skip_relocation, ventura:        "0bb57933695da02bc7d2dafbc7de149e370a82186a9c43c6d619d19bbfb2e0ae"
    sha256 cellar: :any_skip_relocation, monterey:       "ce57ea801bfd314ae43bfc31088daa4a2cfb65b93162b49b204120840ba4203d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "312c9ada3e642ad81b4cdfdc01d64b614ec03a6c98df7b303b5dce97f4122312"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/prestd"
  end

  test do
    (testpath/"prest.toml").write <<~EOS
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    EOS

    output = shell_output("#{bin}/prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/prestd version")
  end
end
