class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "429a58d166d1166c5820c431372a01ebac3eea173b7cf506542292b922bf9d9e"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9087e51798a9cb24290ad4c353e8b0fd8ca224f092f780263996467b68655205"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c70efe1ea037a541c832e405ce706579c8300c03c1d02304b85990931fc55db9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e3e2be409b91db6930d06df56deff6044b23083a59f13ef72fe190b3d4921ea"
    sha256 cellar: :any_skip_relocation, ventura:        "4bf6154533d9ab0540f7b2bcff5450f9260a24ea85caeb261c2a51e5f5804739"
    sha256 cellar: :any_skip_relocation, monterey:       "82dc5aa5c844f4b09d6f2f22aca3576ed8554f6368ad8cf51ba377963eb586bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "684748737da8e8199a5faa77ea64f004a4c7e6d7f81437aa5f9777456a63a2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee7ee4b42c98be558c6309da74b17fac8dafb2403916821cd3ce93331eb9d494"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"cdebug", "completion")
  end

  test do
    # need docker daemon during runtime
    expected = if OS.mac?
      "cdebug: Cannot connect to the Docker daemon"
    else
      "cdebug: Got permission denied while trying to connect to the Docker daemon"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
