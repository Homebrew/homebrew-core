class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.7.tar.gz"
  sha256 "6d40946158c16cf86b56a293f5d60bed3f1035623828ccc1a6b978f544bee9a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3dbfaf165ff3bea24ae6338898b0c7c9cfd4f40159fae4baf3be85817078787"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ba4f4354a82f549922148e52b5609d08b4626345c236524adfde5b03a58077b"
    sha256 cellar: :any_skip_relocation, monterey:       "3538dd8c9221a2e5833666424260074fdd73e4b365347f6867fbd3fd02e70778"
    sha256 cellar: :any_skip_relocation, big_sur:        "29465c4f9de04051b380e18fa690e7efe85e4b95251506c69107068d65ff5d3c"
    sha256 cellar: :any_skip_relocation, catalina:       "fcfa6be8b058562250133dc9af637e4d2a89c4c66f195cb138bbeae4e3e42f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb22a7c53b4408c419276b608761a26526f5bf47a0add9b01498fb787fd05ff7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
