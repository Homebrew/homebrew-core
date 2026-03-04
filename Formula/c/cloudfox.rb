class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v2.0.0a.tar.gz"
  version "2.0.0a"
  sha256 "1969874756822d615232d7732fce0498cba1c5b245118bfc8117f9201b8346a5"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ead04a919711474a7b3a9363df9340bc8bb85e2c3fd7a0e63f51a6a533b6235"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ead04a919711474a7b3a9363df9340bc8bb85e2c3fd7a0e63f51a6a533b6235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ead04a919711474a7b3a9363df9340bc8bb85e2c3fd7a0e63f51a6a533b6235"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a81f06ab4851042af2af7d68a25746e4d2388c0e43cff304948ed9df03baa7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "637e800050a1864fa57739572aff43bde77e2ec29d1a75e27cce5c2e5c59f6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f0207d3be754f77166cb0d3c34a5c778572e003c0a614a83148d11c592b4e09"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", shell_parameter_format: :cobra)
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
