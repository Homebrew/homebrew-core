class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/1.6.0.tar.gz"
  sha256 "acee6e33f0fcdf6bc24bbc3763933262def4c443804bd408ddded97a3856edf0"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69086512c5f931766d9624947565707e0f57165138486f8e785c3b5f5e9504c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69086512c5f931766d9624947565707e0f57165138486f8e785c3b5f5e9504c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69086512c5f931766d9624947565707e0f57165138486f8e785c3b5f5e9504c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2795491bc328c2679c1441a855f503505c5f51bc5e0c453262e981c40ed75935"
    sha256 cellar: :any,                 x86_64_linux:      "aa208cbaf29f6a385437a50304add53914c6c4f14c8eda10aed8b364a0f41610"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
