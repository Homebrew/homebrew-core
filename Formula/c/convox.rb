class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.25.14.tar.gz"
  sha256 "1f22b9d5bcc8ead949c1aa5520796379d4ba683b8f329d15c72692114e3d545a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a84d3f8acf35d5086c4b4131b22a1a5fb6467851372c37cee6b73501ca8ad5d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07fe8c2c4e744e77889e295d953f9bee42af4296e7c7b01aacd10b7665b6df5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb1ed9b2c883ab634b9bcd4a54f571ab236c38f75ff1882228854947e64a1d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ea5a0507494443b3ba99da6c7614017603f6f20e6ff4f2b080fe5d37a5a07ded"
    sha256 cellar: :any,                 x86_64_linux:      "e8f97873d1a84449af4947a09b12656a0fb4a713f7faf144d988a1f5a705e00c"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
