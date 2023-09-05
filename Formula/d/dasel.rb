class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v2.3.6.tar.gz"
  sha256 "aebed9ddaa1daf5de9080e2ed6eff1c90606a2ad2d9988d4b4fdbb243b1a71d7"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de28534dc17d3661710b108a288ccfe891d5200a5a41245370745b0d1994eab3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "490d90e16f116e27a544ddced23095ecc0b44dcdc8ab50b605430a716feb1403"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7b65e3382c81996498549f1ffb529762d9674771345dcebd4d2b3e8b4b73293"
    sha256 cellar: :any_skip_relocation, ventura:        "ac9891f9e099950dc63cd98f82be2cfdb2ad0a990f421235bdea0d51840c9e8b"
    sha256 cellar: :any_skip_relocation, monterey:       "e159f67aa8b13dc66705a9b03f2309bb01ca5c40bd8c44fc7d2d329023455f12"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7c06bd9ced60d4146873b3724f572ba90eba73f95d926e5409fb8d18a593c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b3018709ed7134740a3eddbebb2264b4fb92f6fd0b425e5a930457018f42e76"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/v2/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end
