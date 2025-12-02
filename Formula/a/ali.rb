class Ali < Formula
  desc "Generate HTTP load and plot the results in real-time"
  homepage "https://github.com/nakabonne/ali"
  url "https://github.com/nakabonne/ali/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "3eed2d7cbdf8365cad78833362e99138e7c0945d6dbc19e1253f8e0438a72f81"
  license "MIT"
  head "https://github.com/nakabonne/ali.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6c75f79f91b80211c17b21b777050f1df8a6081ac567ffb5556d9609148b4d1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1fa319e59e535c54935058ab8a8ffdf177bec32fac05003168bd9c15021da164"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e26d87beadff780ef72f728cef8042f6ef0f8224e9e5745b35c74653fa5a47a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b5c51e93206dc7cfcedf87724c1333f0318a2c9d3901f1c34c523363cd32469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb5f1fb53b82dc72ed40d5a00b4e7bf9a66955ebb12ecb5d882ec0f6d73db811"
    sha256 cellar: :any_skip_relocation, sonoma:         "f10493d0b0865a6b278382ceee4ac84b9f373b238721f949061a188eb03172ab"
    sha256 cellar: :any_skip_relocation, ventura:        "c1e614a1bb025e707f4535377c85ff1ed81dceb47e73f6079c7c3fc519cc7cd7"
    sha256 cellar: :any_skip_relocation, monterey:       "45e2b734e1662d30b68c7b47b2684399c5ecb5e13747f6f8036830983daefd37"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3b64df658e252aac13d38bf1fd272c53ba58f55efd77861e01622de875d06626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b61422195f1f744328bea5388328f63b68c45e04543d117a83d8d5a155561cc"
  end

  depends_on "go" => :build

  conflicts_with "nmh", because: "both install `ali` binaries"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit= -X main.date=#{time.iso8601}}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ali --duration=10m --rate=100 http://host.xz 2>&1", 1)
    assert_match "failed to start application: failed to generate terminal interface", output

    assert_match version.to_s, shell_output("#{bin}/ali --version 2>&1")
  end
end
