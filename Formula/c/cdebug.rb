class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "6133fb7286fba476674b54e2f008c35a4b28f209e3072c3e0a75c69c5deeee81"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef52781baa184fe68498a97f6684583118f6ec03d688a8753bca4bf72c490ecd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0356a3e1ee8c7ce5de59c4f24b2a7b17d9126a5284f9677d7fd91c82b4d07e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0356a3e1ee8c7ce5de59c4f24b2a7b17d9126a5284f9677d7fd91c82b4d07e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0356a3e1ee8c7ce5de59c4f24b2a7b17d9126a5284f9677d7fd91c82b4d07e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2327854d9210bdb2ae313d45966bd3194337d84a798a282d64b6df0d304cc8ba"
    sha256 cellar: :any_skip_relocation, ventura:        "dea3380567fbf906b88881ae2524d57c71dd712266fa282aab6bbc50bdc96174"
    sha256 cellar: :any_skip_relocation, monterey:       "8080dc9eacd768e9d5b5a1503b1a1443b2559f5b5ee1cba9a8124c4756f75b40"
    sha256 cellar: :any_skip_relocation, big_sur:        "535e557d4bf258b532bc57f1e6fd88bdcddc3328050110142c2668a6bcc157eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a853028bc69423f191b40acbe2d59eca2d7d793139fa46dea447ae38962762"
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
      "cdebug: Permission denied while trying to connect to the Docker daemon socket"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
