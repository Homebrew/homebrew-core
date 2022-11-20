class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.9.0.tar.gz"
  sha256 "7faa50566898a53b0fff81973e7161874eabec45ad11f9defcd0e04310bddaff"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be96211cba209d92f8942def737bbbfa8d170ff761dffb7c20e25e9359acafc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81590d64aedce57e3f56411b41132f8796924d6c58a1f4afcabf46d48f1b7fb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6afb26ce47dc98f69f63b85f43430eb33dcdfca7db4435139aee986a7d9a466"
    sha256 cellar: :any_skip_relocation, ventura:        "f34da43ae19c08285cdb0715944b48e19d0d1f558000595646d32af01b8272eb"
    sha256 cellar: :any_skip_relocation, monterey:       "a7cf571588de2b97f014d8b75153c036527ed4be56b3b2d9cdd0052328fbebe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d1d6635edc807dee2eafde699ee9239440b6b6d52fec775e2ce6aee88ea466f"
    sha256 cellar: :any_skip_relocation, catalina:       "aebb62c90ed44f52fed1d90161159d5a8154528a3e3c2ca486140d8a9067a2fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "686eaf2862de957dfb581462b6cf01bfbfa3c6901624edf324640b4f257e7d9a"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.BuildTime=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")
    # CI runs in a Docker container, so the test does not run as expected.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
