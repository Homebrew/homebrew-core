class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.4.0.tar.gz"
  sha256 "559fa141ccc7d8b23f4bf063928c7abed24af78c9e87f1d0e240fe120021c2af"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eb50f7ffb941684c8b34a7b29df1cb9adac1c701b1bd3b9e60479179fa9fb109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0648c142ff702b4083fa83e7768f67139afd1f50b026db5745982d03ba896b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca6205aaf127361fcceed8ddbbd0e5fe02d76fc376718fd7e048ee655db9d7ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7024d305a578287337cc4db25e25532109fc78397daa738c5c4e0448515eca19"
    sha256 cellar: :any_skip_relocation, sonoma:         "663603d6450c90d42d84e2d3d4c647cbfa15d84b936338e25652e3605e78e091"
    sha256 cellar: :any_skip_relocation, ventura:        "529aaec3549db4d2613b66432fe6d1b2dfb2808c5e8089f523e62f450066be33"
    sha256 cellar: :any_skip_relocation, monterey:       "82cc6b3caf14d13b72fcaab9e17b37afb36debbd518cac6af4722b7bdaba4a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57cb08038aa3c666770a7fc13ebb2f9c8a1d816fac5f9b4346b2be540f13925e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
