class Gotz < Formula
  desc "Displays timezones in your terminal"
  homepage "https://github.com/merschformann/gotz"
  url "https://github.com/merschformann/gotz/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "44258a08762fda0f0f6eb5afe4eefc8256539da1a8215f77048c1c6f0f0070e5"
  license "MIT"
  head "https://github.com/merschformann/gotz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4317835c1730257089a65d977a268a6eba6a834f123d9ef66abf9f58e7a93159"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4317835c1730257089a65d977a268a6eba6a834f123d9ef66abf9f58e7a93159"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4317835c1730257089a65d977a268a6eba6a834f123d9ef66abf9f58e7a93159"
    sha256 cellar: :any_skip_relocation, sonoma:        "84b6e31be4184df0b1eed709ac11f277ba1364332218b51ed04cf82014cd2d69"
    sha256 cellar: :any_skip_relocation, ventura:       "84b6e31be4184df0b1eed709ac11f277ba1364332218b51ed04cf82014cd2d69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f61d161279f1eeba162c82dfe5f4c15d5ba6ab01ca3eb34d099673ef07e1d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bd56b05cc1dcc194266bd0c14e305cefbd3861c4c52c04dbddcfecf49b44312"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotz -version")
    assert_match "Local", shell_output("#{bin}/gotz -timezones America/New_York")
  end
end
