class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.2.0.tar.gz"
  sha256 "00360d70839e0ff5ba1b5f5c7a57f17af20a9730960c37f70cdd5d77d3b70d16"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e51eecd32266c9cf551e105995a08436c397a6ea970fde9ecc4b899ced66039d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c001bf7dc639495e5db1032f30fb6fb6cafd43a0945165ffbe18959f3a594bdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7d62c778b0b206d5c3acbb11496a75dc27f1139df52aa3ad2e8d389b71b2fb6"
    sha256 cellar: :any_skip_relocation, ventura:        "cb49c4e17823b64e0793a29128603b8f6ab225e0e9defcd3ec23ae25c7b34ff4"
    sha256 cellar: :any_skip_relocation, monterey:       "bc5cc90be98ebe0e54270d9ab462f15e432809f99989c6ac659df0351b33304e"
    sha256 cellar: :any_skip_relocation, big_sur:        "15a243ea7790dad85d0968f79cb87d44c48b155db47dd3e3da6d7388142c7c86"
    sha256 cellar: :any_skip_relocation, catalina:       "495252f58cd272c9a4a10c1d55a02be32404252eb5887f949d86dacb50d25b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6392a627beed2a6c218f68b695e15a6814a0df4d116ad61fc84915dca234c764"
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
