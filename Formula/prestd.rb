class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.14.tar.gz"
  sha256 "65716a72f7dca448e0b4c7082dd8c7dee57c29320eae5c44b2f38fab0d77dae7"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d36101ed0dfe00423b432f2dd88bf9fb318329bb87d8707693887e7fb6ff0a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1453c844c1b83b0cf1b1804e8dd816f67773a2748f1d6ab841c6677ba3626220"
    sha256 cellar: :any_skip_relocation, monterey:       "8183621bcf2dd5e99b8018e0fd7bab2b1131e26359d1c3f24fce1279ae69f183"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d6227ec3206bba71b3a54e8e3d9a0e6655c30b9faffac4cb643a544e940d33f"
    sha256 cellar: :any_skip_relocation, catalina:       "d60f5161e40eee32173c42943c6db3f94a202771e21d8d5be299a86408cd9554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "195f00694ec9027f6fbfc8c6321058802fe52e142336c3a7bf2828608836fa08"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}",
      "./cmd/prestd"
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

    output = shell_output("prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("prestd version")
  end
end
