class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "08048785e9769750813ead6857b193603cdf62eb584d459d119ef5f66686a2a8"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bb6daf0b0f9bb12a2ef093d6c65d4ebc9d3362d1cbc1844efb8c903084b62b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bb6daf0b0f9bb12a2ef093d6c65d4ebc9d3362d1cbc1844efb8c903084b62b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bb6daf0b0f9bb12a2ef093d6c65d4ebc9d3362d1cbc1844efb8c903084b62b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bf636fd4b7426973fec648c100e75f21270a6d31b851e89f7b72f510549e5a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04a9ceee3f8a544485232b1b1b4ef2c633cb5088e75a430539069390c6105e40"
    sha256 cellar: :any,                 x86_64_linux:  "72211d70ae60eda613b7602ea71555587acbae9134bedbb1cebda3177d96fca1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", shell_parameter_format: :cobra)
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
