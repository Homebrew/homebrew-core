class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/v1.6.2.tar.gz"
  sha256 "4cf14accb5e027fc5ecc5804679a4b52f9aae076b4bdbe33a5c002fc84e0f437"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "254e5ce1014c934dc1a458a19ffa295ed88c5eb9ad876de204e4355a045152e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "ebca81b1aa110727edbf76008a810986242980f0ce2dd11e63f2da110fc94991"
    sha256 cellar: :any_skip_relocation, catalina:      "8ee0a1f1762e51172f840f467df41b25db0087b5a97712e862388674e075ec89"
    sha256 cellar: :any_skip_relocation, mojave:        "070bfb679705896f2b60fb44a8f94b18be862b654a394d254f2795a225173807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10e78cc1b779aecbdf9d856ab70366f45417814b321f8ceb2978c7e571895642"
  end

  depends_on "go" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}/curlie -X GET httpbin.org/headers 2>&1")
  end
end
