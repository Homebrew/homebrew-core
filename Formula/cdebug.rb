class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "6157c5bac9d983acba25bb78067797a9a9fc4d0ea332018c2a839df4dafe00a5"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ee7631acabf20d459c95fc6b231be29a8812c052319e31b979dc6aa6eb1b030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11ed7134204a7256fc681ab8a9fce5c80b3189b6ef4355113edb55232bbf0025"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "366629482ca680cd92263511326b3fcc8bfaad6d23d2ba3c86323abad9be35b2"
    sha256 cellar: :any_skip_relocation, ventura:        "06988641ea843c8e745f4cc40de7f4bb5f02188f540a5c16a2972aade7837e61"
    sha256 cellar: :any_skip_relocation, monterey:       "f7834a874e53b9992029e3565e3580fd05afea7c22404e35b5c72c0cd60583b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "be911b895a7d27e6b1caf85b5a1d9870ce5b2dc240e537712a476cb7f15c4a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a60bd536c1df50387af2aa9ef1da2ed7073496b264fa40178f53407afb10bbc1"
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
