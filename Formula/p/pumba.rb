class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/1.2.1.tar.gz"
  sha256 "1b4cebc76127d1557cf63a1aa8493506d434321bb55e2b09e65d4f88b8c5707e"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cff1960d49a0be15691339f89e8069d7820d769bf7420e9b5513247b670092b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cff1960d49a0be15691339f89e8069d7820d769bf7420e9b5513247b670092b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cff1960d49a0be15691339f89e8069d7820d769bf7420e9b5513247b670092b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "306c23343c0854f79b767ed66c55821d2fcf7b1f36de629c0a73e449b3c7de24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73142262c8323399cd361b28186cedc1530fbccf2763817b0d780d9336d2e570"
    sha256 cellar: :any,                 x86_64_linux:  "7c45b4903a52abca7aae91ac96206365e9e1a05e4b371a4d2a6db95aea3b8cd6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")

    # Linux CI container on GitHub actions exposes Docker socket but lacks permissions to read
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "/var/run/docker.sock: connect: permission denied"
    else
      "Is the docker daemon running?"
    end

    assert_match expected, shell_output("#{bin}/pumba rm test-container 2>&1", 1)
  end
end
