class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.9.tar.gz"
  sha256 "47713300e4a5117bbce30413d26d3b27ef032012a94173d80b6ec3cfab41af1f"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62dfa958b199df7d328d9d6bf14585c09f4b69b28fa1ab5f43d473c2197736c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "782387d19993ce425672bbeba52c1df220c340dbda2a73910992c9cb4d3c2b0f"
    sha256 cellar: :any_skip_relocation, catalina:      "9543bc0eb5034af0d647f005bf924f9045a311d57935be138c92716dd5de89b7"
    sha256 cellar: :any_skip_relocation, mojave:        "403142c4e3190cf4bd1cfe1ba8c4c7930c2c12b17f19b331c4555e042f83fe07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "125e5854500bacb8c8d6abe864a5df9663a42d0d1eb0ea0d363d6e6db960d17f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}",
      "./cmd/prestd"
  end

  test do
    output = shell_output("prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("prestd version")
  end
end
