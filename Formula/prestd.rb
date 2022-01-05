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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "555e7be54368728dfe940b7d36959388cb2ac6cfc4435f0dab992a317c4d6cd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31d4f9e1828b45a875cffec1a63ed06e4b5827704ea7182724fefcd79493eb47"
    sha256 cellar: :any_skip_relocation, monterey:       "61c504ea5b4c8bd9b9a370c2cd17ee8d66ddf83f2a1442ebb58189fb6f3c4e20"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba50bba408362f67a3880862236ff2ce528f7a957f044c0b1d6892e9022f6fd9"
    sha256 cellar: :any_skip_relocation, catalina:       "e1c0e19760c908b80a20136c0556124fe99f085f7869cff547d2175491ea6d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6229e2c2b1e93e718e0e486421c856e2cfcfa7630223c841724170d9eff6721"
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
