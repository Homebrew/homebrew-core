class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "ab9f91320f16673dbf450ed3c1790eb4e4786934a1f5a0817eb82a582f09d1eb"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "955b248f7fcd1ffa54b0a6e42afd32a50f2887221fea8bcb59c77c289e623315"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c39329e18e617f4648808d9902bc5031ba3dd5f47381ccd9f0adb47a29285e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2c39329e18e617f4648808d9902bc5031ba3dd5f47381ccd9f0adb47a29285e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2c39329e18e617f4648808d9902bc5031ba3dd5f47381ccd9f0adb47a29285e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4318b378fe0ac302f48bbe6d238cce3ae2883eea0e6e3bda5c8142dab338c466"
    sha256 cellar: :any_skip_relocation, ventura:       "4318b378fe0ac302f48bbe6d238cce3ae2883eea0e6e3bda5c8142dab338c466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2052e55da0989f32bd688d2fc5ca9975ec5e6ccc8ef9d7cc0e6da236d687d79b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=brew
      -X github.com/nxtrace/NTrace-core/config.BuildDate=#{time.iso8601}
      -checklinkname=0
    ]
    # checklinkname=0 is a workaround for Go >= 1.23, see https://github.com/nxtrace/NTrace-core/issues/247
    system "go", "build", *std_go_args(ldflags:)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` for linux
    return_status = OS.mac? ? 0 : 1
    output = shell_output("#{bin}/nexttrace --language en 1.1.1.1 2>&1", return_status)
    assert_match "[NextTrace API]", output
    assert_match version.to_s, shell_output("#{bin}/nexttrace --version")
  end
end
