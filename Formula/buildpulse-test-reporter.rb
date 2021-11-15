class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "ead1db68b7826eeb302cebf0bdacd25b835b896b43883b57c94a74c0d96fd0cd"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "632ad07ab1c55c93c4d306abfa7ac5f42eaafd3cfcc0bbc18fe94f5a84550c3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc5b7d41d3e0f9ed4d2f9fd73be416d59eff7002b00a5ac427cb3f987fcc76ba"
    sha256 cellar: :any_skip_relocation, monterey:       "ed568249c719710bdd82997761cfd14533d2224df1aaa6d9f053f4a6a4614e54"
    sha256 cellar: :any_skip_relocation, big_sur:        "57d2559e7c0e34e593c657d55ce05ab7e9773064923f7fce45e7b5e8ff391254"
    sha256 cellar: :any_skip_relocation, catalina:       "6a695e176c6ff0f5d39fe7a9e6967b0b848fbaea26159a28301af612f111080b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb918a49ec30f8a00bb36bd70176621cf6e21307bc0437ef95b8c09263ef94c1"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end
