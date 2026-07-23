class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "578214e12516182b0d0db815ae5aeff9ac7050901889dbb2a033697c94c44967"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15d6ef3cac296aa053552786580e7c8e4a18640623e0c432e0ffaee5f02cfd79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c05a8e01669ef6c31162ba0e8127e651d42df849500611f2b40fc86905dd282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "297aa0fa16bf4dc477e11340f2cd4867ddf99ee917992ab36eeabeb2fe40fac3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbe4888bf05ca45165529ab105b834b001d284b053acd5acdd3760af79c0d547"
    sha256 cellar: :any,                 arm64_linux:   "c793a6510c71a2e06d823774cc18b8419855ec7424772e4fb03ca309244f70d0"
    sha256 cellar: :any,                 x86_64_linux:  "9c53eda3f5cd7bd55e30f4ef189e6efd9cade74b9fa3404e3f1a2559a80d71b7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1", 1)
    assert_match "scan completed", output
  end
end
