class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
      tag:      "v0.11.0",
      revision: "800398060434ce8dfda6b4d182b72e2a9724e9f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85cfb19756bf9778eeef156546ee099f9a44eaccb636df66f14a749129b9f2f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85cfb19756bf9778eeef156546ee099f9a44eaccb636df66f14a749129b9f2f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85cfb19756bf9778eeef156546ee099f9a44eaccb636df66f14a749129b9f2f5"
    sha256 cellar: :any_skip_relocation, ventura:        "1358457c221bed48eaec5ed4030474fde991b91584aadc2348bc0d0a9f35d563"
    sha256 cellar: :any_skip_relocation, monterey:       "1358457c221bed48eaec5ed4030474fde991b91584aadc2348bc0d0a9f35d563"
    sha256 cellar: :any_skip_relocation, big_sur:        "1358457c221bed48eaec5ed4030474fde991b91584aadc2348bc0d0a9f35d563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f4815d9cb249505fe010e10ae33913ed63a12fcb8de7c8dfcef9507e06e0627"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "gpgme" => :build
    depends_on "pkg-config" => :build
    depends_on "device-mapper"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath/"Dockerfile").write <<~EOS
      FROM alpine
      ENV test=homebrew-core
      RUN echo "hello"
    EOS

    assert_match "dive #{version}", shell_output("#{bin}/dive version")
    assert_match "Building image", shell_output("CI=true #{bin}/dive build .", 1)
  end
end
