class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "734d1f42a12b645170925cc1855626dc82a386b4250558baffe416517a9aa710"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25e98c7a599a54bc71fe36e2373d3ca16c34064e77c4f964183978747bbad8a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25e98c7a599a54bc71fe36e2373d3ca16c34064e77c4f964183978747bbad8a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25e98c7a599a54bc71fe36e2373d3ca16c34064e77c4f964183978747bbad8a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "249be5b876c374cbb18e8acfea9f660041786ad2c2b17a1c7fdf0689c1dd29e5"
    sha256 cellar: :any_skip_relocation, ventura:       "249be5b876c374cbb18e8acfea9f660041786ad2c2b17a1c7fdf0689c1dd29e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4142b0e9ff351cd7595b85f9256f76277041456bb0578e88d83e9dd1a4c8b7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
