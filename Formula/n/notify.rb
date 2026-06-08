class Notify < Formula
  desc "Stream the output of any CLI and publish it to a variety of supported platforms"
  homepage "https://docs.projectdiscovery.io/tools/notify/overview"
  url "https://github.com/projectdiscovery/notify/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "ec9f1e6c48f975b58d30162071d954db0cd771ea3f5dc7168f5ecdc73658c0ad"
  license "MIT"
  head "https://github.com/projectdiscovery/notify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e0f75572048c8a133022ffcebec399529075ad0c8e7d0d1bd62b93802014b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7be1bc9e0154bb8c4f496425c468dec71e6a373461aa7883445e57d2d7e2a738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af1cb932e57d925915878389b7a207098b8a3324e0800f1ea5db8b12a42d3bc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aeec01296186f92a51779563e40390db5b65585f2f0f9fc5a4339c23af9199c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1da6aac2df79d0f709092d1b2a9449ad3dfee1fe6fb4b2073635b321540b7895"
    sha256 cellar: :any_skip_relocation, ventura:       "b91f8d7fd9626a85fa58b680effdd66c1bc3aa8b8871c699eeeaa7019ff27b44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eabe485332921912a90cb52151029c5ca2cba52494fdb289d9bcd689870fa94d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b193c3bb416604ece04efc3382efb032885718e2740d26e98d6a6094d6e1eb2b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/notify"
  end

  test do
    assert_match "Current Version: #{version}", shell_output("#{bin}/notify -disable-update-check -version 2>&1")
    output = shell_output("#{bin}/notify -disable-update-check -config \"#{testpath}/non_existent\" 2>&1", 1)
    assert_match "Could not read config", output
  end
end
