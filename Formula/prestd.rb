class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.10.tar.gz"
  sha256 "0267d9f718ae6d7181fc3631d280b12af0534927df6f715598137f8ff1fb93f1"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b89f52d239d98f4da7751a1861524b482a803fa67a82f736577b86eebe88bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f7e525ce2f762739c8e3f33af949046790099d2c81eb8dee6c26483b8b96c04"
    sha256 cellar: :any_skip_relocation, monterey:       "42d34b993a2467cf32b87d4c7efc72526c97fdc54020f8187d4cbfa938320dbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ddeb2d90e3f0376637547d74dccbb46a23cba6c6b579455a0fd477854443229"
    sha256 cellar: :any_skip_relocation, catalina:       "55f91de387918a2d1166c50435c0a9c56c79b23f32a844ad105228f8fea2e57e"
    sha256 cellar: :any_skip_relocation, mojave:         "0ac506e43d96a7cd6b841337d9ddf80167a96da34e177a2ffed460efbf15839e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "555d1beda6082e133ae4c3e8f832cac87e0799f6d5baaaee983214dab86a2236"
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
