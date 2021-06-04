class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/v1.6.0.tar.gz"
  sha256 "7ed115d9d785e587f426e5d7f1e408ce687ed61389b63398fce0e60f3a5f3df8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "254e5ce1014c934dc1a458a19ffa295ed88c5eb9ad876de204e4355a045152e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "ebca81b1aa110727edbf76008a810986242980f0ce2dd11e63f2da110fc94991"
    sha256 cellar: :any_skip_relocation, catalina:      "8ee0a1f1762e51172f840f467df41b25db0087b5a97712e862388674e075ec89"
    sha256 cellar: :any_skip_relocation, mojave:        "070bfb679705896f2b60fb44a8f94b18be862b654a394d254f2795a225173807"
  end

  depends_on "go" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}/curlie -X GET httpbin.org/headers 2>&1")
  end
end
