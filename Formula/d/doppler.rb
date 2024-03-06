class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.67.1.tar.gz"
  sha256 "072fa1bd9b483b034eed8d150f1ac71734dd088e115a17f67d756bd66ce7469b"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "575dbfa0165b0512f32bace023299f0f13cbc1e442e550be74f23c5fd892ab4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d230df6dc29b32b2dc08a7418bf34b360528cfdf1b29d3960112c79bc219ac63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e025fccf709f0b7ab7a989a2cd8c1a640fffb78ccb05adc65a525df5a3872d06"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cc11f1a1a1346a62c9a234958f7fcd53ffb32902f9147e99baa97319bc14105"
    sha256 cellar: :any_skip_relocation, ventura:        "f336ab838e6c70b85c5b5f3371de4a48ee4055b3c68fba41fd3f589ca019df9c"
    sha256 cellar: :any_skip_relocation, monterey:       "ec5de481a3dfbc2f1129f258cf9ac3fcefa0282cfd11ba75b1cb84f51f4837d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ede1cd7d35b81e3e48015ca1d2bcb885d2ddd0ada20f9405a6ea3905eca40b2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
