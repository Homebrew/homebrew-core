class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https://github.com/thevxn/dish"
  url "https://github.com/thevxn/dish/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "52981fda7ad890e7c028c11dc656f11ce2e3842735f48b3d173220ea41a3b458"
  license "MIT"
  head "https://github.com/thevxn/dish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3215eff5fce1b0eca049f90df81d980a3201df0431956f0da031196bd574f095"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3215eff5fce1b0eca049f90df81d980a3201df0431956f0da031196bd574f095"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3215eff5fce1b0eca049f90df81d980a3201df0431956f0da031196bd574f095"
    sha256 cellar: :any_skip_relocation, sonoma:        "f42cb17f7387a4673aa5f912ca620bb48e772a167cdc934263816bfb8019ba34"
    sha256 cellar: :any_skip_relocation, ventura:       "f42cb17f7387a4673aa5f912ca620bb48e772a167cdc934263816bfb8019ba34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0954f4e438d7d0fba720e26ccf2fe1561658b55dd5fcf208b55132e1a2dab289"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dish"
  end

  test do
    ouput = shell_output("#{bin}/dish https://example.com/:instance 2>&1")
    assert_match "error loading socket list: failed to fetch sockets from remote source", ouput
  end
end
